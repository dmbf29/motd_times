const toggleOpen = () => {
  const btn = document.getElementById('btn-show')
  const oldEpisodes = document.getElementById('previous-seasons')
  if (btn) {
    btn.addEventListener('click', (event) => {
      oldEpisodes.classList.toggle('hidden-div');
      btn.remove();
    });
  }
}

export { toggleOpen };
