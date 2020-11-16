# Easit Management Framework for Easit BPS and Easit GO

## Project status
![Test tests with Pester](https://github.com/easitab/EasitManagementFramework/workflows/Test%20tests%20with%20Pester/badge.svg) ![Test source with PSSA and Pester](https://github.com/easitab/EasitManagementFramework/workflows/Test%20source%20with%20PSSA%20and%20Pester/badge.svg)

![Generate and update help](https://github.com/easitab/EasitManagementFramework/workflows/Generate%20and%20update%20help/badge.svg) [![Build status](https://ci.appveyor.com/api/projects/status/jvecjyuro985bgu6?svg=true)](https://ci.appveyor.com/project/easitab/easitmanagementframework)

## Framework outline

These are the functions we would like to have ready in v1 of the framework and we aim to release Q4 2020 / Q1 2021. Once we have all the basic functionality on place there will be a preview release leading up to official stable release of v1.

- Disable-EasitEmailRequestTask
- Disable-EasitImportClientTask
- Disable-EasitScheduledTask :heavy_check_mark:
- Enable-EasitEmailRequestTask
- Enable-EasitImportClientTask
- Enable-EasitScheduledTask :heavy_check_mark:
- Get-EMFConfig :heavy_check_mark:
- Get-EasitEmailRequestMailbox :heavy_check_mark:
- Get-EasitScheduledTask :heavy_check_mark:
- Set-EasitEmailRequestMailboxSetting :heavy_check_mark:
- Set-EMFConfig :heavy_check_mark:
- New-EMFConfig :heavy_check_mark:
- Start-EasitApplication :heavy_check_mark:
- Stop-EasitGOApplication :heavy_check_mark:

This list should be treated as a wishlist more than anything else and could be changed over the time leading up to release. 

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
