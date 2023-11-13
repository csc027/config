# git wrappers
function Invoke-GitAdd { git add $args }
function Invoke-GitAddChunk { git add -p $args }
function Invoke-GitBranch { git branch $args }
function Invoke-GitBranchAll { git branch -a $args }
function Invoke-GitBranchAllVerbose { git branch -avv $args }
function Invoke-GitBranchDelete { git branch -d $args }
function Invoke-GitBranchVerbose { git branch -vv $args }
function Invoke-GitCheckout { git checkout $args }
function Invoke-GitCheckoutBranch { git checkout -b $args }
function Invoke-GitCherryPick { git cherry-pick $args }
function Invoke-GitCommit { git commit -m $args }
function Invoke-GitDiff { git diff $args }
function Invoke-GitDiffCached { git diff --cached $args }
function Invoke-GitDiffNameOnly { git diff --name-only $args }
function Invoke-GitDiffNameStatus { git diff --name-status $args }
function Invoke-GitDiffTool { git difftool $args }
function Invoke-GitFetch { git fetch $args }
function Invoke-GitFetchAll { git fetch --all $args }
function Invoke-GitFetchAllPrune { git fetch --all --prune $args }
function Invoke-GitFetchPrune { git fetch --prune $args }
function Invoke-GitFetchTags { git fetch --tags $args }
function Invoke-GitGrep { git grep $args }
function Invoke-GitInit { git init $args }
function Invoke-GitListTree { git ls-tree --name-only -r $args }
function Invoke-GitLog { git log --decorate --oneline --graph --color $args }
function Invoke-GitLogDiff { git log --decorate --oneline --graph --color --boundary $args }
function Invoke-GitLogDiffLong { git log --decorate --graph --color --boundary $args }
function Invoke-GitLogLong { git log --decorate --graph --color $args }
function Invoke-GitLogLongPatch { git log --decorate --graph --color -p $args }
function Invoke-GitLogLongPatchFollow { git log --decorate --graph --color -p --follow -- $args }
function Invoke-GitLogPatch { git log --decorate --oneline --graph --color -p $args }
function Invoke-GitLogPatchFollow { git log --decorate --oneline --graph --color -p --follow -- $args }
function Invoke-GitLogRegularExpression { git log --decorate --color -G $args }
function Invoke-GitLogSearch { git log --decorate --color -S $args }
function Invoke-GitMerge { git merge $args }
function Invoke-GitMergeTool { git mergetool $args }
function Invoke-GitMv { git mv $args }
function Invoke-GitPull { git pull $args }
function Invoke-GitPush { git push $args }
function Invoke-GitPushSetUpstream { git push -u $args }
function Invoke-GitPushTags { git push --tags $args }
function Invoke-GitRebase { git rebase $args }
function Invoke-GitRebaseInteractive { git rebase --interactive $args }
function Invoke-GitRemote { git remote -v $args }
function Invoke-GitRemoteAdd { git remote add $args }
function Invoke-GitReset { git reset $args }
function Invoke-GitShow { git show $args }
function Invoke-GitShowUpstreamBranches { git for-each-ref --format='%(refname:short) <- %(upstream:short)' refs/heads $args }
function Invoke-GitStash { git stash $args }
function Invoke-GitStashApply { git stash apply $args }
function Invoke-GitStashList { git stash list $args }
function Invoke-GitStashPop { git stash pop $args }
function Invoke-GitStashShow { git stash show -p $args }
function Invoke-GitStashShowNameOnly { git stash show $args }
function Invoke-GitStashUntracked { git stash -u $args }
function Invoke-GitStatus { git status $args }
function Invoke-GitTag { git tag $args }

#github cli wrapper
function Invoke-GitHubCli { gh.exe $args }
function Invoke-GitHubCliAlias { gh.exe alias $args }
function Invoke-GitHubCliApi { gh.exe api $args }
function Invoke-GitHubCliAuth { gh.exe auth $args }
function Invoke-GitHubCliBrowse { gh.exe browse $args }
function Invoke-GitHubCliCodespace { gh.exe codespace $args }
function Invoke-GitHubCliConfig { gh.exe config $args }
function Invoke-GitHubCliExtension { gh.exe extension $args }
function Invoke-GitHubCliGist { gh.exe gist $args }
function Invoke-GitHubCliGpgKey { gh.exe gpg-key $args }
function Invoke-GitHubCliIssue { gh.exe issue $args }
function Invoke-GitHubCliLabel { gh.exe label $args }
function Invoke-GitHubCliOrg { gh.exe org $args }
function Invoke-GitHubCliPr { gh.exe pr $args }
function Invoke-GitHubCliProject { gh.exe project $args }
function Invoke-GitHubCliRelease { gh.exe release $args }
function Invoke-GitHubCliRepo { gh.exe repo $args }
function Invoke-GitHubCliRuleset { gh.exe ruleset $args }
function Invoke-GitHubCliSearch { gh.exe search $args }
function Invoke-GitHubCliSecret { gh.exe secret $args }
function Invoke-GitHubCliSshKey { gh.exe ssh-key $args }
function Invoke-GitHubCliStatus { gh.exe status $args }
function Invoke-GitHubCliVariable { gh.exe variable $args }

#neovim wrapper
function Invoke-Neovim {
	$MultislotArgument = @('--startuptime', '-c', '--cmd', '-S', '-l', '-ll', '-u', '-i', '-s', '-w', '-w', '-W', '--listen');
	$ArgumentList = @();
	for ($i = 0; $i -lt $args.Count; $i++) {
		if ($args[$i] -is [string]) {
			if ($args[$i] -in $MultislotArgument) {
				# Skip the next argument if this flag is a multislot argument
				$ArgumentList += @($args[$i++]) + @($args[$i]);
			} elseif (
				$args[$i] -notlike '-*' -and
				$args[$i] -notlike '+*' -and (
					$args[$i] -like '*`**' -or
					$args[$i] -like '~*'
				)
			) {
				# If a glob/tilde is detected, wrap the glob/tilde value with a
				# :next command execution
				$ArgumentList += @("+n $($args[$i])");
			} else {
				$ArgumentList += @($args[$i]);
			}
		} elseif ($args[$i] -is [Array]) {
			$ArgumentList += @($args[$i]);
		} else {
			$ArgumentList += @($args[$i]);
		}
	}

	nvim.exe $ArgumentList;
}

$Aliases = @{
	#git
	'ga' = 'Invoke-GitAdd';
	'gap' = 'Invoke-GitAddChunk';
	'gb' = 'Invoke-GitBranch';
	'gba' = 'Invoke-GitBranchAll';
	'gbav' = 'Invoke-GitBranchAllVerbose';
	'gbd' = 'Invoke-GitBranchDelete';
	'gbv' = 'Invoke-GitBranchVerbose';
	'gc' = 'Invoke-GitCommit';
	'gd' = 'Invoke-GitDiff';
	'gdc' = 'Invoke-GitDiffCached';
	'gdn' = 'Invoke-GitDiffNameOnly';
	'gds' = 'Invoke-GitDiffNameStatus';
	'gdt' = 'Invoke-GitDiffTool';
	'ge' = 'Invoke-GitRebase';
	'gei' = 'Invoke-GitRebaseInteractive';
	'gf' = 'Invoke-GitFetch';
	'gfa' = 'Invoke-GitFetchAll';
	'gfap' = 'Invoke-GitFetchAllPrune';
	'gfp' = 'Invoke-GitFetchPrune';
	'gft' = 'Invoke-GitFetchTags';
	'gg' = 'Invoke-GitGrep';
	'gh' = 'Invoke-GitStash';
	'gha' = 'Invoke-GitStashApply';
	'ghl' = 'Invoke-GitStashList';
	'ghp' = 'Invoke-GitStashPop';
	'ghw' = 'Invoke-GitStashShow';
	'ghwn' = 'Invoke-GitStashShowNameOnly';
	'ghu' = 'Invoke-GitStashUntracked';
	'gi' = 'Invoke-GitInit';
	'gk' = 'Invoke-GitCheckout';
	'gkb' = 'Invoke-GitCheckoutBranch';
	'gl' = 'Invoke-GitLog';
	'glp' = 'Invoke-GitLogPatch';
	'glpf' = 'Invoke-GitLogPatchFollow';
	'gld' = 'Invoke-GitLogDiff';
	'gldl' = 'Invoke-GitLogDiffLong';
	'gll' = 'Invoke-GitLogLong';
	'gllp' = 'Invoke-GitLogLongPatch';
	'gllpf' = 'Invoke-GitLogLongPatchFollow';
	'glr' = 'Invoke-GitLogRegularExpression';
	'gls' = 'Invoke-GitLogSearch';
	'glt' = 'Invoke-GitListTree';
	'gmg' = 'Invoke-GitMerge';
	'gmt' = 'Invoke-GitMergeTool';
	'go' = 'Invoke-GitRemote';
	'goa' = 'Invoke-GitRemoteAdd';
	'gp' = 'Invoke-GitPush';
	'gpt' = 'Invoke-GitPushTags';
	'gpu' = 'Invoke-GitPushSetUpstream';
	'gq' = 'Invoke-GitCherryPick';
	'gr' = 'Invoke-GitReset';
	'gs' = 'Invoke-GitStatus';
	'gt' = 'Invoke-GitTag';
	'gu' = 'Invoke-GitPull';
	'gv' = 'Invoke-GitMv';
	'gw' = 'Invoke-GitShow';
	'gwu' = 'Invoke-GitShowUpstreamBranches';

	#github cli
	'ghb' = 'Invoke-GitHubCli';
	'ghalias' = 'Invoke-GitHubCliAlias';
	'ghapi' = 'Invoke-GitHubCliApi';
	'ghauth' = 'Invoke-GitHubCliAuth';
	'ghbrws' = 'Invoke-GitHubCliBrowse';
	'ghcode' = 'Invoke-GitHubCliCodespace';
	'ghcfg' = 'Invoke-GitHubCliConfig';
	'ghext' = 'Invoke-GitHubCliExtension';
	'ghgist' = 'Invoke-GitHubCliGist';
	'ghgpg' = 'Invoke-GitHubCliGpgKey';
	'ghisu' = 'Invoke-GitHubCliIssue';
	'ghlbl' = 'Invoke-GitHubCliLabel';
	'ghorg' = 'Invoke-GitHubCliOrg';
	'ghpr' = 'Invoke-GitHubCliPr';
	'ghproj' = 'Invoke-GitHubCliProject';
	'ghrls' = 'Invoke-GitHubCliRelease';
	'ghrepo' = 'Invoke-GitHubCliRepo';
	'ghrule' = 'Invoke-GitHubCliRuleset';
	'ghfind' = 'Invoke-GitHubCliSearch';
	'ghsct' = 'Invoke-GitHubCliSecret';
	'ghssh' = 'Invoke-GitHubCliSshKey';
	'ghst' = 'Invoke-GitHubCliStatus';
	'ghvar' = 'Invoke-GitHubCliVariable';

	#neovim
	'nvim' = 'Invoke-Neovim';
};


foreach ($Key in $Aliases.Keys) {
	while (Test-Path -Path "Alias:\$Key") {
		Remove-Item -Path "Alias:\$Key" -Force;
	}
	Set-Alias -Name $Key -Value ($Aliases.$Key);
}

Export-ModuleMember -Function * -Alias *;
