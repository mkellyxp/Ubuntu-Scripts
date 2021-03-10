 
#!/bin/bash

if [ $USER == 'root' ]
then
    echo ""
    echo "********************************************"
    echo "* Run this as your user, NOT root or sudo! *"
    echo "********************************************"

else
    echo ""
    echo "******************************************"
    echo "* Installing Erlang, Elixir, and Phoenix *"
    echo "******************************************"
    
    sudo apt install erlang elixir inotify-tools nodejs npm
    
    mix local.hex
    mix archive.install hex phx_new 1.5.8
    
    echo ""
    echo "************************************************"
    echo "* Install Complete!                            *"
    echo "* Use: 'mix phx.new hello' to create a new app *"
    echo "************************************************"
    
fi
