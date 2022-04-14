# Contribution Quick Start

I do not accept pull requests on the github mirror, please use patches instead.

Anyone can contribute to musicctl. First you need to clone the repository:

    git clone https://git.sr.ht/~theorytoe/musicctl
    cd musicctl

When making changes, ensure the following:

- Ensure that your code is properly formatted properly with stylua.
- Ensure that everything works as expected.
- Do not forget to update the docs.

Once you are happy with your work, you can create a commit (or several
commits). Follow these general rules:

- Limit the first line (title) of the commit message to 60 characters.
- Use a short prefix for the commit title for readability with `git log --oneline`.
- Use the body of the commit message to actually explain what your patch does
  and why it is useful.
- Address only one issue/topic per commit.
- If you are fixing a ticket, use appropriate
  [commit trailers](https://man.sr.ht/git.sr.ht/#referencing-tickets-in-git-commit-messages).
- If you are fixing a regression introduced by another commit, add a `fix:`
  trailer with the commit id and its title.

There is a great reference for commit messages in the
[Linux kernel documentation](https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes).

Before sending the patch, you should configure your local clone with sane
defaults:

    git config format.subjectPrefix "[PATCH] musicctl.lua"
    git config sendemail.to "~theorytoe/musicctl-devel@lists.sr.ht"

And send the patch to the mailing list:

    git send-email --annotate -1

Before your patch can be applied, it needs to be reviewed and approved. Approval
will be indicated by a reply to your patch with a Reviewed-by trailer.

You can follow the review process via email and on the
[web ui](https://lists.sr.ht/~theorytoe/musicctl-devel/patches).

Wait for feedback. Address comments and amend changes to your original commit.
Then you should send a v2 (and maybe a v3, v4, etc.):

    git send-email --annotate -v2 -1

Once your patch has been reviewed and approved it will be applied and pushed.
