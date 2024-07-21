function good_yen (){
  const radioButton = document.getElementById('radio_button');
  const radioButtonTrue = document.getElementById('post_select_yen_true');

  radioButton.addEventListener('change', () => {
    if (radioButtonTrue.checked) {
      const insertPoint = document.getElementById('insert_point');
      const messages = ['Good yen!', 'Good yen!', 'Good yen!', 'ありがとう！', 'いいね！', 'すてき！', 'さすがです！', 'すばらしい！'];
      const messageNo = Math.floor(Math.random() * messages.length);
      const html = `
        <div id="id_balloon">
          <p class="balloon">${messages[messageNo]}</p>
        </div>`;
      insertPoint.insertAdjacentHTML('afterend', html);
    } else {
      const html = document.getElementById('id_balloon');
      if (html != null) {
        html.remove();
      };
    };
  });
};

window.addEventListener('load', good_yen);
