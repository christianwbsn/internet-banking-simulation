	program internetbanking;
	{Spesifikasi: program untuk simulasi internet banking}
	{I.S semua file terdefinisi dan dapat berhasil diload}
	{F.S program dapat dijalankan sesuai fungsi dan fiturnya}
	uses sysutils,dos,typeandvar,filemanagement,validation,accountmanagement,datemanagement,transactionmanagement;//pemanggilan unit yang digunakan
	
	BEGIN
		GetDate(Year,Month,Day,WDay);//mengextract tanggal saat ini(real time)
		GetTime(Hour,Min,Sec,HSec);//mengextract waktu saat ini(real time)
					//USER INTERFACE and USER EXPERIENCE
		writeln('-----------------------------------Selamat datang di Layanan Internet Banking-----------------------------------');
		writeln('                                               >>> BANK XYZ <<<                          ');
		writeln('                                           "Melayani Sepenuh Hati"                      ');
		writeLn('                                           Tanggal:  ',Day,' ',convMonth(Month),' ',Year,'                             ');
		writeln('                                                  ',L0(Hour),':',L0(Min),' WIB                       ');
		writeln('-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-');
		writeln();
		//---------------------------------------------------------------------//
		//Pemrosesan Fitur
		repeat	
			//Inisialisasi
			writeln('> Masukkan perintah!:  ');
			validateCommand;//Validasi perintah
			if(command=c1) then
			begin
				validateLoad;
				writeln();//formatting UI/UX
			end;
			if(command=c2) then
			begin
				login;
				writeln();//formatting UI/UX
			end;
			if(command=c25) then
			begin
				logout;
				writeln();//formatting UI/UX
			end;
			if(command=c3) or (command='lihat rekening') then
			begin
				lihatRekening;
				writeln();
			end;
			if(command=c4) or (command='informasi saldo') then
			begin
				informasiSaldo;
				writeln();//formatting UI/UX
			end;
			if(command=c5) or (command='lihat aktivitas transaksi') then
			begin
				lihatriwayat;
				writeln();//formatting UI/UX
			end;
			if(command=c6) or (command='pembuatan rekening')  then
			begin
				bikinrekening;
				writeln();//formatting UI/UX
			end;
			if(command=c7) then
			begin
				setor(arrtrans,arrrek);
				writeln();//formatting UI/UX
			end;
			if(command=c8) then
			begin
				tarik(arrtrans,arrrek);
				writeln();//formatting UI/UX
			end;
			if(command=c9) then
			begin
				transfer;
				writeln();//formatting UI/UX
			end;
			if(command=c10) then
			begin
				bayar;
				writeln();//formatting UI/UX
			end;
			if(command=c11) then
			begin
				beli;
				writeln();//formatting UI/UX
			end;
			if(command=c12) or (command='penutupan rekening') then
			begin
				tutupakun(arrRek);
				writeln();//formatting UI/UX
			end;
			if(command=c13) or (command='perubahan data nasabah') then
			begin
				perubahanDataNasabah;
				writeln();//formatting UI/UX
			end;
			if(command=c14) or (command='penambahan autodebet')  then
			begin
				penambahanAutoDebet(arrRek);
				writeln();//formatting UI/UX
			end;
			if(command='help') then
			begin
				help;
				writeln();//formatting UI/UX
			end;
			if(command=c15) then
			begin
				exit;
			end;
		until(command=c15)	//terminasi program(kondisi berhenti)
	END.
