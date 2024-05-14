%%shell

chmod 755 -R tesseract/src/training/tesstrain.sh


%%shell

!combine_tessdata -e tesseract/tessdata/eng.traineddata eng.lstm


%%shell

rm -rf train/*
./tesseract/src/training/tesstrain.sh --fonts_dir fonts \
    --fontlist 'Earth Momma' \
    --lang eng \
    --linedata_only \
    --langdata_dir langdata_lstm \
    --tessdata_dir ./tesseract/tessdata \
    --save_box_tiff \
    --maxpages 10 \
    --output_dir train



%%shell

rm -rf output/*
OMP_THREAD_LIMIT=16 lstmtraining \
	--continue_from eng.lstm \
	--model_output output/font_name \
	--traineddata tesseract/tessdata/eng.traineddata \
	--train_listfile train/eng.training_files.txt \
	--max_iterations 400




%%shell

lstmtraining --stop_training \
	--continue_from output/font_name_checkpoint \
	--traineddata tesseract/tessdata/eng.traineddata \
	--model_output output/earthmomma.traineddata



#**HOW TO USE IT ?**


---
Download and paste the fontname.taineddata inside this location

** FOR WINDOWS :**

---


C:\Program Files\Tesseract-OCR\tessdata

**FIRE THIS IN COMMAND LINE IN COMMAND PROMPT**

---
*tesseract.exe imagename textfile -l fontname*

***example : ***:

---


*tesseract.exe image.jpg text.txt -l fontname*


