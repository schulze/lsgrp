// See the LICENSE file for copyright and license details.

#include <stdio.h>
#include <err.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>

const char *usage = "Usage: lsgrp GROUPNAME\n";

int
main(int argc, char *argv[]) {
	char *group;
	char **member;

	if (argc != 2) {
		fprintf(stderr, usage);
		return 2;
	}
	group = argv[1];

	// get info about our group
	errno = 0;
	struct group *grp = getgrnam(group);
	if (grp == NULL) {
		if (errno != 0)
			err(1, "%s: can't read group database: %s", argv[0], strerror(errno));
		fprintf(stderr, "%s: %s:  group does not exists\n", argv[0], argv[1]);
		return 2;
	}

	// get the users with group as their primary group
	errno = 0;
	struct passwd *user = getpwent();
	while (user != NULL) {
		if ((*user).pw_gid == (*grp).gr_gid) {
			printf("%s\n", (*user).pw_name);
		}
		user = getpwent();
	}
	if (errno != 0)
		err(1, NULL);

	// get the secondary members.
	for (member = (*grp).gr_mem; *member != NULL; member++) {
		printf("%s\n", *member);
	}
	return 0;
}
