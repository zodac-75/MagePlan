# MagePlan

A leveling companion for mages in **WoW Forever**: talent plans with highlights, gear upgrade check, quest reward picker, shatter and polymorph alerts, crafting and disenchant advice, and an XP tracker. English and Swedish.

**Download:** [CurseForge](https://www.curseforge.com/wow/addons/mageplan)

## Releasing a new version

1. Update the code.
2. Put the new version's notes at the top of `CHANGELOG.md`, starting with a heading like `# MagePlan 1.6.2`.
3. Push to `main`. GitHub Actions sees the new version, tags it, packages the addon as `MagePlan-1.6.2.zip` and uploads it to CurseForge with the changelog.

To test first, use a version like `# MagePlan 1.7.0-beta1`. CurseForge marks it as a beta, and only players who opted in to betas get it. Rename the heading to `# MagePlan 1.7.0` later to release it to everyone.

Pushes that don't change the version in the first line of `CHANGELOG.md` don't release anything.

The upload needs the repository secret `CF_API_KEY` (a CurseForge API token).

## License

MIT
