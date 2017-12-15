#! /usr/bin/env bash

source tools/lib.sh

COMMANDS=($(get_papis_commands))

mkdir -p dist
out=dist/bash-completion.sh

echo > ${out}

cat >> ${out} <<EOF

_papis (){
local cur
# Pointer to current completion word.
# By convention, it's named "cur" but this isn't strictly necessary.

COMPREPLY=()   # Array variable storing the possible completions.
cur=\${COMP_WORDS[COMP_CWORD]}
prev=\${COMP_WORDS[COMP_CWORD-1]}

case "\$cur" in
  -*)
  COMPREPLY=( \$( compgen -W "$(get_papis_flags | paste -s )" -- \$cur ) );;
  * )
  COMPREPLY=( \$( compgen -W "$(get_papis_commands | paste -s )" -- \$cur ) );;
esac

case "\$prev" in
EOF

for cmd in ${COMMANDS[@]}; do

echo ${cmd}

cat >> ${out} <<EOF
  ${cmd})
    COMPREPLY=( \$( compgen -W "$(get_papis_flags ${cmd} | paste -s )" -- \$cur ) )
    ;;

EOF

done

cat >> ${out} <<EOF

esac

return 0
}


complete -F _papis papis
EOF