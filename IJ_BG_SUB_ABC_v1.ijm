macro "background substraction by rolling ball, then auto contrast" {
	getDateAndTime(year, month, week, day, hour, min, sec, msec);
	while (nImages>0) {
		selectImage(nImages);
		close();
	}
	run("Clear Results");
	updateResults;
	roiManager("reset");
	run("Close All");
	print("\\Clear");
	print("Start process at: "+day+"/"+month+"/"+year+" :: "+hour+":"+min+":"+sec+"");
	dir1=getDirectory("Please choose source directory");
	list=getFileList(dir1);
	Dialog.create("processing options");
	Dialog.addCheckbox("use batch mode ", true);
	Dialog.addNumber("Rolling ball diameter [pixels]", 60);
	Dialog.addCheckbox("Light background ", true);
	Dialog.addCheckbox("Sliding paraboloid  ", false);
	Dialog.addCheckbox("Auto contast / brightness ", true);
	Dialog.addSlider("Enhance Contrast saturation value", 0.01, 1, 0.35);
	Dialog.addCheckbox("Overwrite (else a separate folder will be used) ", false);	
	Dialog.show();
	batch = Dialog.getCheckbox();
	ball = Dialog.getNumber();
	back = Dialog.getCheckbox();
	slide = Dialog.getCheckbox();
	ACB = Dialog.getCheckbox();
	sat = Dialog.getNumber();
	OVR = Dialog.getCheckbox();	
	if(back == 1){
		back = "light";
		backr = "light";
	}else {
		back = "";
		backr = "dark";
	}
	if(slide == 1){
		slide = "sliding";
		slider = "used";
	}else {
		slide = "";
		slider = "not used";
	}
	if(OVR == 0){
		dir2=getDirectory("Please choose destination directory ");
	}
	if(ACB == 1){
		ACBr = "used";
	}else{
		ACBr = "NOT used";
	}
	setBatchMode(batch);
	if (batch == 1){
		print("batch mode on");
	}else{
		print("batch mode off");
	}
	print("processing directory: "+dir1+"");
	print("___");
	print("Settings:");
	print("Rolling ball diameter [pixels]: "+ball+"");
	print("Background: "+backr+"");
	print("Sliding paraboloid: "+slider+"");
	print("Auto contast / brightness: "+ACBr+" at saturation of "+sat+" pixles");
	print("___");
	N=0;
	for (i=0; i<list.length; i++) {
		path = dir1+list[i];
		open(path);
		title = getTitle;
		title2 = File.nameWithoutExtension;
		print("image title: "+title+"");
		selectWindow(""+title+"");
		run("Subtract Background...", "rolling="+ball+" "+back+" "+slide+"");
		if(ACB == 1){
			run("Enhance Contrast", "saturated="+sat+"");
		}
		if(OVR == 1){
			saveAs("tif", dir1+title2+".tif");
			print("saved as: "+dir1+title+"");
		}else{
			saveAs("tif", dir2+title2+"_corrected.tif");
			print("saved as: "+dir2+title2+"_corrected.tif");
		}
		while (nImages>0) {
			selectImage(nImages);
			close();
		}
		N++;
		print("Image# "+N+"");
		}
	print("___");
	print("Finished process at: "+day+"/"+month+"/"+year+" :: "+hour+":"+min+":"+sec+"");
	waitForUser("Summary"," "+N+" files corrected.");
		}
