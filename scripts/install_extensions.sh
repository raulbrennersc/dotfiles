while read p; do
  codium --install-extension "$p"
done < ~/dotfiles/vscodium/extensions