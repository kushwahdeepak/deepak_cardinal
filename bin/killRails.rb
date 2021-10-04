#!/usr/bin/ruby

def kill_process pid
  res = system("kill -9 #{pid}")
  if(res)
    print "killed pid #{pid}\n"
  else
    raise "could not kill pid #{pid}\n"
  end
end

def kill_from_server_pid
  fname = 'tmp/pids/server.pid'
  if(File.exists?(fname))
    pid = `cat #{fname}`
    kill_process pid
    `rm #{fname}`
  else
    print fname+" doesn't exist.\n"
  end
end

def kill_listening_on_3k
  res = `lsof -n -i4TCP:3000| grep LISTEN` #ruby    73267 makedon    9u  IPv4 0x5cc31b7a1c183d73      0t0  TCP *:hbci (LISTEN)
  if res.length > 0
    pid = res.split(' ')[1]
    puts "process #{pid} is listenning to 3000"
    kill_process pid
  else
    print "no process is listening to 3000\n"
  end
end

kill_from_server_pid
kill_listening_on_3k