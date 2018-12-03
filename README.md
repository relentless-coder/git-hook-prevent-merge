## What is this?

A bash script to prevent merging a specific branch. Eg: `./protect-merge.sh $branch_to_prevent $path_to_project_folder`

## What is the need?

At my current company, we don't merge our local development to our local feature branches. So I have setup this script. However, in the future I may add more hooks


## Usage

1. Clone this repo
2. Execute the bash script from within the repo folder.

The pattern is `./protect-merge.sh $branch_to_prevent $path_to_project_folder`. So something like, `./protect-merge.sh development ~/Workspace/blog-api`.
This would place a `prepare-commit-msg` hook in your projects `.git/hooks` folder. Hence everytime you'd try to run `git merge development` the process would fail.

```
 ALERT!!!!!!!! ACTION NOT ALLOWED

 You are trying to merge development into your branch.

 RUN `git reset --merge` to abort this merge
 Not committing merge; use 'git commit' to complete the merge.
```

**NOTE: You still need to run `git reset --merge` to completely reject the merge.**
