#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#define BUFF_SIZE 1024

void show_usage(void);

/**
 * main - turn on advanced Vim features on or off
 *
 * Description: Takes an argument, on or off.
 *
 * When turned on, .vimrc will be created with some minimal
 * changes that allows you to easily work with Vim.
 *
 * Example:
 *	- Line numbers
 *  - Easier terminal opening with Ctrl + J
 *	- Easier window switching. Ctrl + W + <arrow key>
 *	- Better background and syntax highlighting
 *
 * @argc: cmdline counter...
 * @argv: cmdline args - requires one of two options. on | off
 *
 * Return: 0 on success, non-zero on error
 */
int main(int argc, char *argv[])
{
	char *username = getlogin(); /* fetch username */
	char *vimrc_file;
	/* set the path to the user's .vimrc file */
	sprintf(vimrc_file, "/home/%s/.vimrc", username);
	if (argc != 2)
		show_usage();
	FILE *vimrc_unused = fopen("/src/vimrc.unused", "r");

	if (vimrc_unused == NULL)
	{
		fprintf(stderr, "[!] Couldn't open sources file\n%s\n", strerror(errno));
		return (-2); /* file opening failed */
	}
	FILE *vimrc = fopen(vimrc_file, "w");

	if (vimrc == NULL)
	{
		fprintf(stderr, "[!] File creation failed!\n%s\n", strerror(errno));
		fclose(vimrc_unused);
		return (-3);
	}
	if (!strcmp(argv[1], "on"))
	{
		/* set Vim options */
		char buff[BUFF_SIZE];

		while (fgets(buff, BUFF_SIZE, vimrc_unused) != NULL)
			fputs(buff, vimrc);
		printf(".vimrc file updated... enjoy the new Vim experience\n");
	}
	else if (!strcmp(argv[1], "off"))
	{
		fputs("", vimrc); /* replace content with nothing */
		printf("Vim set to default\n");
	}
	else if (!strcmp(argv[1], "--help") || !strcmp(argv[1], "-h"))
		show_usage(); /* show help and exit */
	else
		show_usage();

	/* close files */
	fclose(vimrc_unused);
	fclose(vimrc);

	return (0);
}

/**
 * show_usage - prints help message and exit
 */
void show_usage(void)
{
	fprintf(stderr, "Usage: more-vim {on | off}\n");
	exit(-2);
}
