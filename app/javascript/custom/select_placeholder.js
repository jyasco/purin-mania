document.addEventListener('turbo:load', function() {
  const selects = document.querySelectorAll('select.select-bordered');
  
  selects.forEach(select => {
    const placeholder = select.querySelector('option[value=""]');
    
    // プレースホルダーの色を設定
    select.style.color = '#C5B6A8'; // placeholderの色

    select.addEventListener('change', function() {
      if (this.value) {
        this.style.color = '#2C1803'; // 通常のテキスト色
      } else {
        this.style.color = '#C5B6A8'; // placeholderの色
      }
    });

    // フォーカス時の処理
    select.addEventListener('focus', function() {
      if (this.value === '') {
        placeholder.hidden = true;
      }
    });

    // フォーカスが外れた時の処理
    select.addEventListener('blur', function() {
      if (this.value === '') {
        placeholder.hidden = false;
        this.style.color = '#C5B6A8'; // placeholderの色
      }
    });
  });
});