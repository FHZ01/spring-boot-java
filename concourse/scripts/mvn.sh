#!/bin/bash

cd $git_resource # Chnage Directory into the Git volume so we can access our source code

mvn compile # Run the MVN compile command to compile our Maven code

cd ..

cp -r $git_resource/target/* ./code # Copy the compiled Maven code into the ./code directory so we can pass it to the next Task
