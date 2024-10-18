document.addEventListener('turbo:load', function() {
  const addImageBtn = document.getElementById('add-image-btn');
  const container = document.getElementById('image-upload-container');
  
  if (addImageBtn && container) {
    let imageCount = parseInt(container.dataset.imageCount) || 0;

    addImageBtn.addEventListener('click', function() {
      if (imageCount < 3) {
        const newField = document.createElement('div');
        newField.className = 'mb-2 relative';
        const fieldId = Date.now();
        newField.innerHTML = `
          <label for="post_post_images_attributes_${fieldId}_image" class="file-input-label flex">
            <span class="flex-none px-4 py-2 rounded-l bg-main text-white">ファイルを選択</span>
            <span class="flex-grow px-4 py-2 rounded-r bg-white text-placeholder truncate" data-file-name>ファイルが選択されていません</span>
          </label>
          <input class="hidden" accept="image/*" type="file" name="post[post_images_attributes][${fieldId}][image]" id="post_post_images_attributes_${fieldId}_image">
        `;
        container.insertBefore(newField, addImageBtn.parentNode);
        imageCount++;
        
        // 新しく追加されたフィールドにもイベントリスナーを設定
        setupImagePreview(newField.querySelector('input[type="file"]'));
      }
      if (imageCount >= 3) {
        addImageBtn.style.display = 'none';
      }
    });

    // 既存のファイル入力フィールドにイベントリスナーを設定
    document.querySelectorAll('#image-upload-container input[type="file"]').forEach(setupImagePreview);
  }

  // プレビュー表示のセットアップ関数
  function setupImagePreview(fileInput) {
    fileInput.addEventListener('change', function(e) {
      const file = e.target.files[0];
      const fileNameSpan = e.target.closest('.relative').querySelector('[data-file-name]');
      if (file) {
        fileNameSpan.textContent = file.name;
        const reader = new FileReader();
        reader.onload = function(e) {
          const previewContainer = fileInput.closest('.relative');
          const existingPreview = previewContainer.querySelector('img');
          if (existingPreview) {
            existingPreview.src = e.target.result;
          } else {
            const previewImg = document.createElement('img');
            previewImg.src = e.target.result;
            previewImg.className = "mt-2 w-24 h-24 object-cover rounded";
            previewContainer.appendChild(previewImg);
          }
        }
        reader.readAsDataURL(file);
      } else {
        fileNameSpan.textContent = 'ファイルが選択されていません';
      }
    });
  }
});