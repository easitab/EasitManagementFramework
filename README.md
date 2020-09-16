# Easit Management Framework for Easit BPS and Easit GO

## Branch model and development process

* Head branches<br/>
The repository has two branches with unlimited life: master and development. Master corresponds to the latest officially delivered version. Development is our development branch where we develop new functionality and continuously develop Easit Management Framework.

* Release branches<br/>
Before a new release is delivered, we freeze the code and only allow bug fixes. This is done in a release segment (release / VERSION) that is based on development. Meanwhile, the development of new functions can continue towards development. When the release is ready for delivery it will be merged to master with a release tag. The final release from this tag is then built. After release, the release branch will also be added to development.

* Feature branches<br/>
Development is done in feature branches (feature / X). Feature branches are short-lived as they are usually merged into development when the feature is complete. In conjunction with the fact that they will be merged for development and erased, we will make a rebase so that a fixed forward merge becomes possible. Note that it is perfectly normal to revive the same feature branch for the next sprint if it has been decided that the work will continue.<br/>
In gitflow, feature branches are typically found only in the developer's own repository. However, to enable review, collaboration and handover of work, our feature branches are often located in the central repository area. Keep in mind that an easy-to-understand story often has a higher value than it should correspond to the exact order that things happened during development. For example, a code review could lead to existing commits in the feature branch being redone instead of being rebuilt with new commits.<br/>
Compare with a chef who invents a new recipe: when to write down the recipe in a cookbook, it is probably not with exactly the steps she performed when the recipe was invented, but with steps that are logical and do not take unnecessary detours.

* Hotfix branch<br/>
When we need to make corrections in one or more releases, we create a hotfix branch per release to be corrected (hotfix / VERSION).
We then create a bug fix branch (bugg/ID) from each hotfix branch and merge it via an pull request.
