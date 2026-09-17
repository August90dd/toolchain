#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <err.h>
#include <sys/wait.h>

int main()
{
    pid_t pid;
    pid = fork();

    if (pid == -1)
        err(EXIT_FAILURE, "fork");

    if (pid == 0) {
        printf("child PID: %d\n", getpid());
        pause(); 	
    } else {
        printf("parent PID: %d\n", getpid());
        int status;
        do {
            int ret = waitpid(pid, &status, WUNTRACED | WCONTINUED);
            if (ret == -1)
                err(EXIT_FAILURE, "waitpid");

            if (WIFEXITED(status))
                printf("Child exited normal, status = %d\n", WEXITSTATUS(status));
            else if (WIFSIGNALED(status))
                printf("Child killed by signal %d\n", WTERMSIG(status)); 
            else if (WIFSTOPPED(status))
                printf("Child stoped by signal %d\n", WSTOPSIG(status)); 
            else if (WIFCONTINUED(status)) 
                printf("Child continued\n");
        } while (!WIFEXITED(status) && !WIFSIGNALED(status));
        exit(EXIT_SUCCESS);
    }
}
