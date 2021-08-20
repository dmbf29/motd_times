const timezoneChange = () => {
  const timeZones = document.querySelector('#time_zones')
  if (timeZones) {
    // timeZones.addEventListener('change', (event) => {
    $('.select2').on('select2:select', function (event) {
      const newZone = event.currentTarget.value
      let url = window.location.href.split('?')[0] += `?timezone=${newZone}`;
      window.location.href = url;
    });
  }
}

export { timezoneChange };
