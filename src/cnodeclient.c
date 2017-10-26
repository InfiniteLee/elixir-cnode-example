
/* cnode_c.c */

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <limits.h>
#include <string.h>

#include "erl_interface.h"
#include "ei.h"

#define BUFSIZE 1000

int main(int argc, char **argv) {
  int fd;                                  /* fd to Erlang node */

  erl_init(NULL, 0);

  if (erl_connect_init(1, "secretcookie", 0) == -1)
    erl_err_quit("erl_connect_init");

  char hostname[HOST_NAME_MAX];
  gethostname(hostname, HOST_NAME_MAX);

  char node[] = "e1@";
  strcat(node, hostname);

  if ((fd = erl_connect(node)) < 0)
    erl_err_quit("erl_connect failed");
  fprintf(stderr, "Connected to %s\n\r", node);

  // http://erlang.org/doc/man/erl_connect.html#erl_reg_send
  ETERM *msg = erl_format("{cnode, ~s}", "hello");
  int resp = erl_reg_send(fd, "complex", msg);

  fprintf(stderr, "sync response: %i\n\r", resp);

  // http://erlang.org/doc/man/erl_connect.html#erl_rpc
  ETERM *terms = {erl_mk_int(3)};
  ETERM *list = erl_mk_list(&terms, 1);

  ETERM *syncresp = erl_rpc(fd, "Elixir.Complex", "double", list);

  fprintf(stderr, "async response: %i\n\r", ERL_INT_VALUE(syncresp));
  
  erl_free_term(msg);
  erl_free_term(terms);
  erl_free_term(list);
  erl_free_term(syncresp);
}
