#================================================
# Variables and Functions
#================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'

# Source NVM for the script
# https://unix.stackexchange.com/a/184512/194420
# https://github.com/nvm-sh/nvm/issues/1290
if [ -f ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
elif command -v brew; then
  # https://docs.brew.sh/Manpage#--prefix-formula
  BREW_PREFIX=$(brew --prefix nvm)
  if [ -f "$BREW_PREFIX/nvm.sh" ]; then
    . $BREW_PREFIX/nvm.sh
  fi
fi

heading () {
tput reset
echo -e "${BLUE}
                                 ..:--====++++++====--::.                                 
                           .:-=++=--::..          ...:--=++=-:.                           
                       .:-+=-:.                            .:-=+=:.                       
                    .-=+-:          .::----====----::.          :-=+-.                    
                 .-+=-.       .:-=++++++++++++++++++++++=--:       .:=+-.                 
               :=+-.      :-=+++++++++++++++++++++++++++++++++-:      .-+=:               
             :==:      :=++++++++++++++++++++++++++++++++++++++++=:      :=+:             
           :==:     .=++++++++++++++++++++++++++++++++++++++++++++++=:     :=+:           
         .=+:     :=+++++++++++++++++++++++++++++++++++++++++++++++-:..      :+=.         
        -+=     :++++++++++++++++++++++++++++++++++++++++++++++++-             -+-        
       =+:    .=++++++++++++++++++++++++++++++++++++++++++++++++:               :+=       
     .=+.    :+++=======--=++++++=-=======++++=======--=++++++++                 .=+.     
    .+=.                   =++++:                       =+++++++.                  =+.    
   .+=               .:---=++++++----:            .:---=++++++++=              .    =+.   
   =+.                =+++++++++++++++-            =+++++++++++++=             =.    ++   
  -+:    =.           .++++++++++++++++.           .++++++++++++++=            ==    :+=  
 .+=    -++            -++++++++++++++++            -+++++++++++++++.          =+-    -+: 
 =+.   .+++=            =+++++++++++++++=            =+++++++++++++++.         +++.   .+= 
.+=    -++++-           .++++++++++++++++-           .++++++++++++++++        :+++=    =+.
-+:    ++++++.           :++++++++++++++++.           -+++++++++++++++-       =++++    :+-
=+.   .++++++=            =+++++++++++++++=            =+++++++++++++++      :+++++:   .+=
++    :+++++++=           .++++++++++++++++-           .+++++++++++++++     .++++++-    ++
++    :++++++++:           -+++++++++++++++:            -++++++++++++++     =++++++-    ++
++    :+++++++++.           =+++++++++++++-              =++++++++++++-    -+++++++-    ++
=+.   .+++++++++=           .+++++++++++++   :           .++++++++++++    :++++++++:    +=
-+:    ++++++++++-           :+++++++++++:  .+-           :++++++++++-    +++++++++    :+-
.+=    -++++++++++:           =+++++++++-   =++:           =++++++++=    =++++++++=    =+.
 =+.   .+++++++++++           .++++++++=   :++++           .++++++++.   :+++++++++.   .+= 
 .+=    -++++++++++=           :+++++++.  .+++++=           :++++++-   .+++++++++-    -+: 
  =+:    =++++++++++-           =+++++-   =++++++-           =+++++    =++++++++=    .+=  
   =+.   .+++++++++++.           ++++=   -++++++++.           ++++:   :+++++++++.    ++   
   .+=    .=+++++++++=           :+++.  .+++++++++=           :++=   .+++++++++.    =+.   
    .+=     =+++++++++=           =+-   =++++++++++=           =+.   =+++++++=.    =+.    
     .++.    -+++++++++:           =   -++++++++++++:          .-   -+++++++-    .=+.     
       =+:    .=++++++++.             :++++++++++++++.             .++++++=:    :+=.      
        -+-     :+++++++=             +++++++++++++++=             =+++++:     -+-        
         .=+:     :++++++=           =++++++++++++++++-           -++++:     :+=.         
           :+=:     :=++++:         :++++++++++++++++++:         :++=:     :=+:           
             :+=:     .:=++         ++++++++++++++++++++         =-.     :=+-             
               :=+-.      :-       =++++++++++++++++++++=              -+=:               
                 .-+=:.           :++++++++++++++++++++++:         .:=+-.                 
                    .-+=-:         ..::---======---::..         .-=+-:                    
                       .:=+=-:.                            .:-=+=:.                       
                           .:-=++=-::..            ..::-==+=-:.                           
                                 .::--====++++++====--::.                                 

"
tput sgr0
}

description () {
  echo -e ""
  echo -e "${BLUE}## $1${NC}\n "
  tput sgr0
}

message () {
  echo -e "${GREEN} ↳ $1${NC}\n"
  tput sgr0
}

error () {
  echo -e "${RED}x $1${NC}"
  tput sgr0
}

success () {
  echo -e "${GREEN}\xE2\x9C\x94 $1${NC}"
  tput sgr0
}

prompt () {
  echo -en "${BLUE}$1${NC}"
  read -p "" CONT
  tput sgr0
}

# Check if commands exist
does_docker_exist() {
  if ! command -v $1 &> /dev/null
  then
      #command does not exist
      brew install --cask docker
  else
      #command exists
      VERSION=$($1 -v)
      echo -e "${BLUE}$VERSION${NC} ${GREEN}\xE2\x9C\x94${NC}"
      tput sgr0
  fi
}

system_check() {
    do_files_exist $1 $2 $3 $4
    verify_git_branch $1 $4
}

do_files_exist() {
    description "Checking that $1 ($3) exists"

    if [ ! -d $1 ]
    then
        git clone "$3" "$1" --branch "$4"
        if [ ! -f "$1"/"$2" ]
        then
        error "Git clone failed, please resolve this to contine"
        exit;
        fi
    else
        success "$1 exists and looks great!"
    fi
}

verify_git_branch() {
    description "Checking that $1 is on the correct branch"

    BRANCH=$(cd $1 && git rev-parse --abbrev-ref HEAD)
    if [ "$BRANCH" != "$2" ]
    then
      error "$1 is not on the specified branch ($2). Please switch branches and try this update again".
      exit;
    else 
      success "$1 is on the correct branch. Moving on."
    fi
}

isDockerRunning() {
  if [ "$( docker container inspect -f '{{.State.Status}}' $1 )" == "running" ]; 
  then
      echo "1"
  else
     echo "0"
  fi
}

brewIn() { 
  if brew ls --versions "$1" > /dev/null 2>&1; 
  then
      VERSION=$(brew ls --versions "$1")
      echo -e "${BLUE}$VERSION${NC} ${GREEN}\xE2\x9C\x94${NC}"
      tput sgr0
    :
  else
    description "Installing $1"
    brew install "$1"; 
  fi 
}

brewCask() {
  if brew ls --cask --versions "$1" > /dev/null 2>&1; 
  then
      VERSION=$(brew ls --cask --versions "$1")
      echo -e "${BLUE}$VERSION${NC} ${GREEN}\xE2\x9C\x94${NC}"
      tput sgr0
    :
  else
    description "Installing $1"
    brew install --cask "$1";

    if [ "$1" = "xquartz" ]; 
      then
        error "Please note that if XQuartz was installed, you need a reboot for it to work"
    fi
  fi
}

does_homebrew_exist() {
  which -s brew
  if [[ $? != 0 ]] ; then
      # Install Homebrew
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
      success "Homebrew is installed."
  fi
}