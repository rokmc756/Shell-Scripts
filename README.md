Total 124 (delta 43), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (43/43), completed with 12 local objects.
remote: error: Trace: 4808f3e5c0e326cd5d88b6754235513d507a7b0402d55d6fc75574459c18ccbe
remote: error: See http://git.io/iEPt8g for more information.
remote: error: File roles/gpdb/files/greenplum-db-6.18.2-ubuntu18.04-amd64.deb is 174.81 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To https://github.com/rokmc756/gpfarmer.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'https://github.com/rokmc756/gpfarmer.git'
moonjaYMD6T:gpfarmer moonja$ git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch roles/gpdb/files/greenplum-db-6.18.2-ubuntu18.04-amd64.deb'
WARNING: git-filter-branch has a glut of gotchas generating mangled history
	 rewrites.  Hit Ctrl-C before proceeding to abort, then use an
	 alternative filtering tool such as 'git filter-repo'
	 (https://github.com/newren/git-filter-repo/) instead.  See the
	 filter-branch manual page for more details; to squelch this warning,
	 set FILTER_BRANCH_SQUELCH_WARNING=1.
Proceeding with filter-branch...

Rewrite 41f0716d11b5f33c0b512cf689a204dddfa44727 (3/4) (0 seconds passed, remaining 0 predicted)    rm 'roles/gpdb/files/greenplum-db-6.18.2-ubuntu18.04-amd64.deb'
Rewrite 432ae4208d7e7031e4949f5acd9a739038cb3909 (4/4) (0 seconds passed, remaining 0 predicted)
