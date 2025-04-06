#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <sys/wait.h>

#define ERR_EXIT(m) \
	do { \
		perror(m); \
		exit(EXIT_FAILURE); \
	} while (0)

int main()
{
	pid_t pid;
	pid = fork();

	if (pid == -1)
		ERR_EXIT("fork");

    if (pid == 0) {
        printf("child PID: %d\n", getpid());
        pause(); // wait for signal, pause使调用者进程挂起, 直到一个信号被捕获.
                 // 将进程置为可中断睡眠状态, 然后它调用schedule(), 使linux进程调度器找到另一个进程来运行(让出CPU时间片).
        //abort(); // 子进程异常终止(6: SIGABRT)
		//_exit(1);
	} else {
        printf("parent PID: %d\n", getpid());
#if 0   /* define 1 to make child process always a zomie */
        printf("ppid:%d\n", getpid());
        while(1);
#endif
	    int status;
	    /*
	     * int ret = wait(&status); 
	     * int ret = waitpid(-1, &status, 0);
	     * 以上两句等价
	     */
        do {
	        int ret = waitpid(pid, &status, WUNTRACED | WCONTINUED); // pid > 0, 等待其进程ID与pid相等的子进程 
            if (ret == -1)
                ERR_EXIT("waitpid");

            if (WIFEXITED(status)) // 如果子进程正常结束, 返回一个非零值. 
                printf("Child exited normal, status = %d\n", WEXITSTATUS(status));
                                                          // WEXITSTATUS: 如果WIFEXITED非零, 返回子进程退出码.
            else if (WIFSIGNALED(status)) // 子进程因信号而终止 
                printf("Child killed by signal %d\n", WTERMSIG(status)); 
                                                   // WTERMSIG: 如果WIFSIGNALED非零, 返回信号代码.
            else if (WIFSTOPPED(status)) // 子进程捕获到暂停的信号
                printf("Child stoped by signal %d\n", WSTOPSIG(status)); 
                                                   // WSTOPSIG: 如果WIFSTOPPED非零, 返回信号代码.
            else if (WIFCONTINUED(status)) 
                printf("Child continued\n");

        } while (!WIFEXITED(status) && !WIFSIGNALED(status));
        exit(EXIT_SUCCESS);
    }
}
