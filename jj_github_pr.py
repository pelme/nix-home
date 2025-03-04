#!/usr/bin/env python

import itertools
import os
import subprocess

import click
import github


def pr_branch(change_id):
    if change_id == "main":
        return "main"
    return f"pelme-{change_id[:8]}"


def run(*args):
    res = subprocess.run(args, capture_output=True)

    if res.returncode == 0:
        return res.stdout.decode("utf8").strip()

    print("  > " + (" ".join(args)))

    raise Exception(res.stderr.decode("utf8"))


def make_pr(*, commit, change, target_change, repo):
    head = pr_branch(change)
    base = pr_branch(target_change)
    title = run("git", "log", "-1", "--pretty=format:%s", commit)
    body = run("git", "log", "-1", "--pretty=format:%b", commit)

    print(f"{title}", end="")
    run("git", "push", "origin", "--force", f"{commit}:refs/heads/{pr_branch(change)}")

    prs = list(repo.get_pulls(head=f"{repo.owner.login}:{head}"))
    if len(prs) == 0:
        pr = repo.create_pull(title=title, body=body, head=head, base=base)
    elif len(prs) == 1:
        pr = prs[0]
        pr.edit(title=title, body=body, base=base)
    else:
        raise AssertionError(prs)
    print(f" » {pr.html_url}")
    return pr


def get_github_repo():
    remote_url = run("git", "config", "--get", "remote.origin.url")
    _, _, result = remote_url.partition("github.com:")
    return result.removesuffix(".git")


def body_with_relation_chain(*, prs, current_pr):
    relation_chain = "\n".join(
        f"- {'👉' if pr == current_pr else ''} #{pr.number}" for pr in reversed(prs)
    )

    return f"{current_pr.body or ''}\n\n### Relation chain\n{relation_chain}"


@click.command()
@click.argument("revision", default="@-")
def main(revision):
    auth = github.Auth.Token(run("gh", "auth", "token"))
    g = github.Github(auth=auth)
    g_repo = g.get_repo(get_github_repo())

    res = run(
        "jj",
        "log",
        "-r",
        f"::{revision} & mutable()",
        "--no-graph",
        "--color",
        "never",
        "-T",
        """commit_id ++ " " ++ change_id ++ "\n" """,
    )
    commit_change_ids = list(reversed([x.split() for x in res.splitlines()]))
    commit_change_ids.insert(0, (None, "main"))

    prs = []
    for (_target_commit, target_change), (commit, change) in itertools.pairwise(
        commit_change_ids
    ):
        prs.append(
            make_pr(
                commit=commit,
                change=change,
                target_change=target_change,
                repo=g_repo,
            )
        )

    if len(prs) >= 2:
        print("Updating relation chains...", end="")
        for pr in prs:
            pr.edit(body=body_with_relation_chain(prs=prs, current_pr=pr))
        print("done.")


if __name__ == "__main__":
    main()
