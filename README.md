## What is this?

A bash script to prevent merging a specific branch. Eg: `bash protect-merge.sh -b $branch_to_prevent -d $path_to_project_folder`

Inspired by [This wonderful article](https://bl.ocks.org/slattery/5eea0d6ca64687ecba6b)

## What is the need?

At my current company, we don't merge our local development branch into our local feature branches. So I have setup this script to prevent the same.

## Usage

1. Clone this repo
2. Execute the bash script from within the repo folder.

The pattern is: 
`bash protect-merge.sh -b $branch_to_prevent -d $path_to_project_folder`.

So something like, 

```
bash protect-merge.sh -b development -d ~/Workspace/blog-api
```

This would place a `prepare-commit-msg` hook in your project's `.git/hooks` folder. Hence everytime you'd try to run `git merge development` the process would fail.

```
 ATTENTION!! Merge prevented.

 You are trying to merge development into your branch.

 RUN `git reset --merge` to abort this merge

 Not committing merge; use 'git commit' to complete the merge.
```

**NOTE**: You still need to run `git reset --merge` to completely reject the merge.

##Useful Information

`-b` accepts either a single value or a list separated by a comma: **Note:** There shouldn't be any space between the list options, otherwise you'd see a `branch doesn't exist error.`


```
bash protect-merge.sh -b development,test -d ~/Workspace/blog-api

// This would prevent merging test or development into your branch.

```

`-d` should be the absolute path to your project folder. As of now, relative paths are not allowed hence you'd see a `Directory not found` error.
