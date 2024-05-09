# Makefile-Template
Template for C/C++ project with Makefile.

# Note
Use W64devkit to use on Windows => https://github.com/skeeto/w64devkit  
To use in Neovim use the clang compiler => https://clang.llvm.org/  
To change the compilation mode use the variable "config=" release, shipping the default option and debug.  

# Targets
make => Compile the project.  
make run => execute project.  
make build => Compiles and runs the project.  
make clean => Clears the entire project.  

# MACROS
Path to Config in the project => CONFIG_PATH  
Path to Content in the project => CONTENT_PATH  
Project folder name => GAME_NAME  
Current Plaform => PLATFORM_WINDOWS, PLATFORM_LINUX  
Compile mode => DEBUG_MODE, RELEASE_MODE, SHIPPING_MODE  

# Credit @gabriel-oprogramador
My YouTube channel => https://www.youtube.com/@gabriel-oprogramador