# MagePlan

A leveling companion for mages in **WoW Forever**: talent plans with highlights, gear upgrade check, quest reward picker, shatter and polymorph alerts, crafting and disenchant advice, and an XP tracker. English and Swedish.

**Download:** [CurseForge](https://www.curseforge.com/wow/addons/mageplan)

## Releasing a new version

1. Update the code and add the notes for the new version at the top of `CHANGELOG.md`.
2. Push a tag with the version number, for example `1.6.2`.
3. GitHub Actions packages the addon as `MagePlan-1.6.2.zip` and uploads it to CurseForge with the changelog.

The upload needs the repository secret `CF_API_KEY` (a CurseForge API token).

## License

MIT
