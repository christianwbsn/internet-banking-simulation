unit transactionmanagement;
//unit untuk pengaturan transaksi yang dilakukan oleh nasabah

interface

	uses typeandvar,sysutils,accountmanagement,datemanagement,validation,crt,dos;
	var
		dd,mm,yy:word;
	const
		biayatransferIDR=5000;
		biayatransferEURUSD=2;
		
	function isBolehTarik(i:integer;x:string):boolean;//Menentukan apakah suatu rekening memenuhi ketentuan penarikan
	procedure setor(var artrans: arrtransaksi; ar: arrrekening);//Melakukan setoran ke rekening yang dimiliki oleh pengguna
	{I.S artrans dan ar terdefinisi}
	{F.S saldo pada rekening yang dipilih akan dijumlahkan dan transaksi tercatat di file transaksi}
	procedure tarik(var artrans: arrtransaksi; ar: arrrekening);//Melakukan penarikan tunai dari rekening yang dimiliki oleh pengguna
	{I.S artrans dan ar terdefinisi}
	{F.S saldo pada rekening yang dipilih akan dikurangi sesuai ketentuan penarikan dan transaksi tercatat di file transaksi}
	procedure transfer;
	{I.S nomor rekening terdefinisi, data transfer sudah diload}
	{F.S mengubah data pada array rekening dan menambahkan data pada array transfer}
	procedure bayar;
	{I.S nomor rekening terdefinisi, data pembayaran sudah diload}
	{F.S mengubah data pada array rekening dan menambahkan data pada array transfer}
	function convjenisbrg(x:integer):string;
	function convpenyedia(jenis,y:integer):string;
	function convjumlah(a,b,y:integer):longint;
	procedure beli;
	
	
implementation

	function isBolehTarik(i:integer;x:string):boolean;
	var
	yy,mm,dd:word;
	
	begin
		DecodeDate(date,yy,mm,dd);
		if (x='deposito') then
		begin
			if((convjangka(ArrRek.rek[i].jangkaWaktu))*30-(yy-ArrRek.rek[i].tglTransaksi.YY)*365-(mm-ArrRek.rek[i].tglTransaksi.MM)*30-(dd-ArrRek.rek[i].tglTransaksi.DD)<=1) then
			begin
				if((convjangka(ArrRek.rek[i].jangkaWaktu))*30-(yy-ArrRek.rek[i].tglTransaksi.YY)*365-(mm-ArrRek.rek[i].tglTransaksi.MM)*30-(dd-ArrRek.rek[i].tglTransaksi.DD)=1) then
				begin
					if(is31(nextnmonth(convjangka(ArrRek.rek[i].jangkaWaktu),ArrRek.rek[i].tglTransaksi))=False) and (Arrrek.rek[i].tglTransaksi.DD=31) then
					begin
						isBolehTarik:=True;
					end else
					begin
						isBolehTarik:=False;
					end;
				end else
				if((convjangka(ArrRek.rek[i].jangkaWaktu))*30-(yy-ArrRek.rek[i].tglTransaksi.YY)*365-(mm-ArrRek.rek[i].tglTransaksi.MM)*30-(dd-ArrRek.rek[i].tglTransaksi.DD)<1) then
				begin
					isBolehtarik:= True;
				end;
			end else
			begin
				isBolehTarik:=False
			end;
		end else
		if(x='tabungan rencana') then
		begin
			if((convjangka(ArrRek.rek[i].jangkaWaktu))*365-(yy-ArrRek.rek[i].tglTransaksi.YY)*365-(mm-ArrRek.rek[i].tglTransaksi.MM)*30-(dd-ArrRek.rek[i].tglTransaksi.DD)<=1) then
			begin
				if((convjangka(ArrRek.rek[i].jangkaWaktu))*365-(yy-ArrRek.rek[i].tglTransaksi.YY)*365-(mm-ArrRek.rek[i].tglTransaksi.MM)*30-(dd-ArrRek.rek[i].tglTransaksi.DD)=1) then
				begin
					if(isKabisat(convjangka(ArrRek.rek[i].jangkaWaktu)+ArrRek.rek[i].tglTransaksi.YY)) then
					begin
						isBolehTarik:=True;
					end else
					begin
						isBolehTarik:=False;
					end;
				end else
				begin
					isBolehtarik:= True;
				end;
			end else
			begin
				isBolehTarik:=False
			end;
		end else
		if(x='tabungan mandiri') then
		begin
			isBolehTarik:=True;
		end;
	end;
	
	procedure setor(var artrans: arrtransaksi; ar: arrrekening);
	var
	nakun,MU,proses: string;
	k,indekssetor: integer;
	jumlah: longint;
	begin
		if(isLoggedIn) and (isRekLoaded) and (isBayarLoaded)  then
		begin
			if(not(punya(1)) and not(punya(2)) and not(punya(3))) then
			begin
				writeln('> Anda belum memiliki rekening.');
			end else
			begin
				lihatRekening;
				write('> Nomor Rekening : ');readln(nakun);
				if (not(rekbenar(nakun,1)) and  not(rekbenar(nakun,2)) and not (rekbenar(nakun,3))) then
				begin
					repeat
						writeln('> Nomor rekening salah/ tidak dapat ditemukan.');
						write('> Nomor rekening : ');readln(nakun);
					until ((rekbenar(nakun,1)) or(rekbenar(nakun,2))or(rekbenar(nakun,3)))
				end;
				
				for k:=1 to ar.Neff do
				begin
					if (nakun=ar.rek[k].noAkun) then
					begin
						indekssetor:=k;
					end;
				end;
				repeat
					write('> Mata uang yang digunakan: ');
					readln(MU);
					if (MU <> ar.rek[indekssetor].mataUang) then
					begin
						writeln('> Mata uang harus sama dengan mata uang tabungan.');
					end;
				until (MU = ar.rek[indekssetor].mataUang);
				write('> Jumlah setoran: ');
				readln(jumlah);
				writeln();
				writeln('> Anda akan melakukan setoran sebesar ',jumlah,' ',ar.rek[indekssetor].mataUang);
				writeln('> Rekening: ',nakun);
				write('> Proses(y/n) : ');readln(proses);
				if (proses='y') or (proses='Y') then
				begin
					writeln('> Transaksi berhasil');
					DecodeDate(date,yy,mm,dd);
					arrRek.rek[indekssetor].saldo := ar.rek[indekssetor].saldo + jumlah;
					if(arrTrans.Neff<Nmax) then
					begin	
						artrans.Neff:=artrans.Neff+1;
					end else
					if(arrTrans.Neff=Nmax) then
					begin
						for i:=1 to Nmax-1  do    
						begin
							artrans.trans[i]:=arTrans.trans[i+1];
							arTrans.Neff:=Nmax;
						end;
					end;
					artrans.trans[artrans.Neff].noAkun:= ar.rek[indekssetor].noAkun;
					artrans.trans[artrans.Neff].Jenistrans:= 'setoran';
					artrans.trans[artrans.Neff].mataUang := ar.rek[indekssetor].mataUang;
					artrans.trans[artrans.Neff].jumlah := jumlah;
					artrans.trans[artrans.Neff].saldo := arrRek.rek[indekssetor].saldo;
					artrans.trans[artrans.Neff].tglTransaksi.DD:=dd;
					artrans.trans[artrans.Neff].tglTransaksi.MM:=mm;
					artrans.trans[artrans.Neff].tglTransaksi.YY:=yy;
				end else
				begin
					writeln('> Transaksi dibatalkan');
				end;
			end;	
		end else
		if(not(isRekLoaded)) then
		begin
			writeln('> Data rekening belum diload');
		end else
		if(not(isTransLoaded)) then
		begin
			writeln('> Data transaksi belum diload');
		end else
		if(not(isLoggedIn)) then
		begin
			writeln('> Silahkan login terlebih dahulu');
		end;
	end;				
	
	procedure tarik(var artrans: arrtransaksi; ar: arrrekening);
	var
		nakun: string;
		k,indekstarik: integer;
		proses: string; {Mata Uang}
		jumlah: longint;
	begin
		if(isLoggedIn) and (isRekLoaded) and (isBayarLoaded)  then
		begin
			if(not(punya(1)) and not(punya(2)) and not(punya(3))) then
			begin
				writeln('> Anda belum memiliki rekening.');
			end else
			begin
				lihatRekening;
				write('> Nomor Rekening : ');readln(nakun);
				if (not(rekbenar(nakun,1)) and  not(rekbenar(nakun,2)) and not (rekbenar(nakun,3))) then
				begin
					repeat
						writeln('> Nomor rekening salah/ tidak dapat ditemukan.');
						write('> Nomor rekening : ');readln(nakun);
					until ((rekbenar(nakun,1)) or(rekbenar(nakun,2))or(rekbenar(nakun,3)))
				end;
				
				for k:=1 to ar.Neff do
				begin
					if (nakun=ar.rek[k].noAkun) then
					begin
						indekstarik:=k;
					end;
				end;
				write('> Jumlah penarikan: ');
				readln(jumlah);
				if(not(isBolehTarik(indekstarik,arrRek.rek[indekstarik].jenisRek))) then
				begin
					writeln('> Rekening tidak memenuhi ketentuan penarikan.');
				end else
				if(jumlah>arrRek.rek[indekstarik].saldo) then
				begin
					writeln('> Saldo Anda tidak cukup untuk melakukan penarikan.');
				end else
				if(isBolehTarik(indekstarik,arrRek.rek[indekstarik].jenisRek)) and(jumlah<=arrRek.rek[indekstarik].saldo) then
				begin
					writeln();
					writeln('> Anda akan melakukan tarik tunai sebesar ',jumlah,' ',ar.rek[indekstarik].mataUang);
					writeln('> Rekening: ',nakun);
					write('> Proses(y/n) : ');readln(proses);
					if (proses='y') or (proses='Y') then
					begin
						writeln('> Transaksi berhasil');
						DecodeDate(date,yy,mm,dd);
						arrRek.rek[indekstarik].saldo := ar.rek[indekstarik].saldo - jumlah;
						if(arTrans.Neff<NMax) then
						begin
							artrans.Neff:=artrans.Neff+1;
						end else
						if(arTrans.Neff=Nmax) then
						begin
							for i:=1 to Nmax-1  do    
							begin
								artrans.trans[i]:=artrans.trans[i+1];
								artrans.Neff:=Nmax;
							end;
						end;
						artrans.trans[artrans.Neff].noAkun:= ar.rek[indekstarik].noAkun;
						artrans.trans[artrans.Neff].Jenistrans:= 'penarikan';
						artrans.trans[artrans.Neff].mataUang := ar.rek[indekstarik].mataUang;
						artrans.trans[artrans.Neff].jumlah := jumlah;
						artrans.trans[artrans.Neff].saldo := arrRek.rek[indekstarik].saldo;
						artrans.trans[artrans.Neff].tglTransaksi.DD:=dd;
						artrans.trans[artrans.Neff].tglTransaksi.MM:=mm;
						artrans.trans[artrans.Neff].tglTransaksi.YY:=yy;
					end else
					begin
						writeln('> Transaksi dibatalkan');
					end;
				end;
			end;	
		end else
		if(not(isTransLoaded)) then
		begin
			writeln('> Data transaksi belum diload');
		end else
		if(not(isRekLoaded)) then
		begin
			writeln('> Data rekening belum diload');
		end else
		if(not(isLoggedIn)) then
		begin
			writeln('> Silahkan login terlebih dahulu');
		end;
	end;				
	
	procedure transfer;
	
	var
	pilihan,indeksasal,indekstujuan,indeksdata:integer;
	jumlah:longint;
	norek1,norek2,proses,banktujuan,matauang,penerima:string;
	ada:boolean;
	
	begin
		DecodeDate(date,yy,mm,dd);
		if(isLoggedIn) and (isRekLoaded) and (isTransfLoaded) then
		begin
			writeln('> Pilih jenis transfer.');
			writeln('> 1. Antar Rekening');
			writeln('> 2. Antar Bank');
			write('> Pilihan: ');readln(pilihan);
			while ((pilihan<>1) and (pilihan<>2)) do
			begin
				writeln('> Masukan salah!');
				write('> Pilihan: ');readln(pilihan);
			end;
			if (pilihan=1) then
			begin
				if punya(1) or punya(2) or punya(3) then
				begin
					writeln('> Silahkan pilih rekening Anda');
					lihatRekening;
					write('> Masukkan nomor rekening yang akan Anda gunakan: ');readln(norek1);
					while not(rekbenar(norek1,1)) and not(rekbenar(norek1,2)) and not(rekbenar(norek1,3)) do
					begin
						writeln('> Nomor rekening yang Anda masukkan salah.');
						write('> Masukkan nomor rekening yang akan Anda gunakan: ');readln(norek1);
					end;
					write('> Rekening Tujuan: ');readln(norek2);
					write('> Jumlah: ');readln(jumlah);
					ada:=False;
					for i:=1 to arrRek.Neff do
					begin
						if(norek2=arrRek.rek[i].noAkun) then
						begin
							ada:=True;
							indekstujuan:=i;
						end;
						if(norek1=arrRek.rek[i].noAkun) then
						begin
							indeksasal:=i;
						end;
					end;
					if ((isBolehTarik(indeksasal,arrRek.rek[indeksasal].jenisRek))=False) then
					begin
						writeln('> Rekening yang Anda gunakan tidak memenuhi aturan penarikan');
					end else
					if (not(ada)) then
					begin
						writeln('> Nomor rekening tujuan tidak terdaftar.');
					end else
					if((jumlah>arrRek.rek[indeksasal].saldo)) then
					begin
						writeln('> Saldo Anda tidak mencukupi untuk melakukan transaksi.');
					end else
					if(ada) and (jumlah<arrRek.rek[indeksasal].saldo) then
					begin
						for i:=1 to arrData.Neff do
						begin
							if(arrRek.rek[indekstujuan].noNasabah=arrData.data[i].noNasabah) then
							begin
								indeksdata:=i;
							end;
						end;
						writeln();
						writeln('> Anda akan melakukan transfer dana ke :');
						writeln('>    Nomor Rekening: ', norek2);
						writeln('>    Atas nama : ', arrData.data[indeksdata].nama);
						writeln('>    Jumlah : ',jumlah,' ',arrRek.rek[indeksasal].matauang);
						write('> Proses (y/n) : ');readln(proses);
						if(proses='Y')or (proses='y') then
						begin
							writeln('> Transfer berhasil!');
							if(arrRek.rek[indeksasal].matauang=arrRek.rek[indekstujuan].matauang) then
							begin
								arrRek.rek[indeksasal].saldo:=arrRek.rek[indeksasal].saldo-jumlah;
								arrRek.rek[indekstujuan].saldo:=arrRek.rek[indekstujuan].saldo+jumlah;
							end else
							if(arrRek.rek[indeksasal].matauang<>arrRek.rek[indekstujuan].matauang) then
							begin
								arrRek.rek[indeksasal].saldo:=arrRek.rek[indeksasal].saldo-jumlah;
								arrRek.rek[indekstujuan].saldo:=arrRek.rek[indekstujuan].saldo+convmatauang(jumlah,arrRek.rek[indeksasal].mataUang,arrRek.rek[indekstujuan].mataUang,arrMatauang);
							end;
							if(arrTransf.Neff<Nmax) then
							begin
								arrTransf.Neff:=arrTransf.Neff+1;
							end else
							if(arrTransf.Neff=Nmax) then
							begin
								for i:=1 to Nmax-1  do    
								begin
									arrtransf.transf[i]:=arrtransf.transf[i+1];
									arrTrans.Neff:=Nmax;
								end;
							end;
							arrTransf.transf[arrTransf.Neff].noAkunAsal:=arrRek.rek[indeksasal].noAkun;
							arrTransf.transf[arrTransf.Neff].noAkunTujuan:=arrRek.rek[indekstujuan].noAkun;
							arrTransf.transf[arrTransf.Neff].jenis:='dalam bank';
							arrTransf.transf[arrTransf.Neff].namaBankLuar:='-';
							arrTransf.transf[arrTransf.Neff].mataUang:=arrRek.rek[indeksasal].mataUang;
							arrTransf.transf[arrTransf.Neff].jumlah:=jumlah;
							arrTransf.transf[arrTransf.Neff].saldo:=arrRek.rek[indeksasal].saldo;
							arrTransf.transf[arrTransf.Neff].tglTransaksi.DD:=dd;
							arrTransf.transf[arrTransf.Neff].tglTransaksi.MM:=mm;
							arrTransf.transf[arrTransf.Neff].tglTransaksi.YY:=yy;
						end else
						begin
							writeln('> Transfer dibatalkan');
						end;
					end;
				end else
				begin
					writeln('> Anda tidak mempunyai rekening.');
				end;
			end else
			if (pilihan=2) then
			begin
				if punya(1) or punya(2) or punya(3) then
				begin
					writeln('> Silahkan pilih rekening Anda');
					lihatRekening;
					write('> Masukkan nomor rekening yang akan Anda gunakan: ');readln(norek1);
					while not(rekbenar(norek1,1)) and not(rekbenar(norek1,2)) and not(rekbenar(norek1,3)) do
					begin
						writeln('> Nomor rekening yang Anda masukkan salah.');
						write('> Masukkan nomor rekening yang akan Anda gunakan: ');readln(norek1);
					end;
					write('> Bank Tujuan: ');readln(banktujuan);
					write('> Nomor Rekening Tujuan: ');readln(norek2);
					write('> Nama Penerima: ');readln(penerima);
					write('> Mata Uang Rekening Tujuan: ');readln(matauang);
					write('> Jumlah: ');readln(jumlah);
					for i:=1 to arrRek.Neff do
					begin
						if(norek1=arrRek.rek[i].noAkun) then
						begin
							indeksasal:=i;
						end;
					end;
					if ((isBolehTarik(indeksasal,arrRek.rek[indeksasal].jenisRek))=False) then
					begin
						writeln('> Rekening yang Anda gunakan tidak memenuhi aturan penarikan');
					end else
					if((jumlah>arrRek.rek[indeksasal].saldo)) then
					begin
						writeln('> Saldo Anda tidak mencukupi untuk melakukan transaksi.');
					end else
					if(jumlah<arrRek.rek[indeksasal].saldo) and ((isBolehTarik(indeksasal,arrRek.rek[indeksasal].jenisRek))=True) then
					begin
						writeln();
						writeln('> Anda akan melakukan transfer dana ke: ');
						writeln('>    Nomor rekening: ', norek2);
						writeln('>    Bank Tujuan: Bank ',banktujuan);
						writeln('>    Atas nama : ', penerima);
						writeln('>    Jumlah : ',jumlah,' ',arrRek.rek[indeksasal].matauang);
						write('> Proses (y/n) : ');readln(proses);
						if(proses='Y')or (proses='y') then
						begin
							writeln('> Transfer berhasil!');
							if(matauang='IDR') then
							begin
								arrRek.rek[indeksasal].saldo:=arrRek.rek[indeksasal].saldo-jumlah-convmatauang(biayaTransferIDR,'IDR',arrRek.rek[indeksasal].mataUang,arrMatauang);
								arrTransf.Neff:=arrTransf.Neff+1;
							end else
							if(matauang='USD')then
							begin
								arrRek.rek[indeksasal].saldo:=arrRek.rek[indeksasal].saldo-jumlah-convmatauang(biayaTransferEURUSD,'USD',arrRek.rek[indeksasal].mataUang,arrMatauang);
							end else
							begin
								arrRek.rek[indeksasal].saldo:=arrRek.rek[indeksasal].saldo-jumlah-convmatauang(biayaTransferEURUSD,'EUR',arrRek.rek[indeksasal].mataUang,arrMatauang);
							end;
							if (arrTransf.Neff<Nmax) then
							begin
								arrtransf.Neff:=arrTransf.Neff+1;
							end;
							if(arrTransf.Neff=Nmax) then
							begin
								for i:=1 to Nmax-1  do    
								begin
									arrtransf.transf[i]:=arrtransf.transf[i+1];
									arrTransf.Neff:=Nmax;
								end;
							end;
							arrTransf.transf[arrTransf.Neff].noAkunAsal:=arrRek.rek[indeksasal].noAkun;
							arrTransf.transf[arrTransf.Neff].noAkunTujuan:=norek2;
							arrTransf.transf[arrTransf.Neff].jenis:='antar bank';
							arrTransf.transf[arrTransf.Neff].namaBankLuar:='Bank '+banktujuan;
							arrTransf.transf[arrTransf.Neff].mataUang:=arrRek.rek[indeksasal].mataUang;
							arrTransf.transf[arrTransf.Neff].jumlah:=jumlah;
							arrTransf.transf[arrTransf.Neff].saldo:=arrRek.rek[indeksasal].saldo;
							arrTransf.transf[arrTransf.Neff].tglTransaksi.DD:=dd;
							arrTransf.transf[arrTransf.Neff].tglTransaksi.MM:=mm;
							arrTransf.transf[arrTransf.Neff].tglTransaksi.YY:=yy;
						end else
						begin
							writeln('> Transfer dibatalkan.');
						end;
					end;
				end else
				begin
					writeln('> Anda tidak mempunyai rekening.');
				end;
			end;
		end else
		if(not(isTransfLoaded)) then
		begin
			writeln('> Data transfer belum diload');
		end else
		if(not(isMataUangLoaded)) then
		begin
			writeln('> Data mata uang belum diload');
		end else
		if(not(isLoggedIn)) then
		begin
			writeln('> Silahkan login terlebih dahulu');
		end;
	end;								
	
	procedure bayar;
	var
	indeksbayar,k:integer;
	norek,jenis,proses,rekbayar: string;
	jml,denda:longint;
	isBayar:boolean;
	
	begin
		if(isLoggedIn) and (isRekLoaded) and (isBayarLoaded)  then
		begin
			if(not(punya(1)) and not(punya(2)) and not(punya(3))) then
			begin
				writeln('> Anda belum memiliki rekening.');
			end else
			begin
				isBayar:=False;
				writeln('> Silahkan masukkan nomor rekening yang akan Anda gunakan untuk pembayaran');
				lihatRekening;
				write('> Nomor Rekening : ');readln(norek);
				if (not(rekbenar(norek,1)) and  not(rekbenar(norek,2)) and not (rekbenar(norek,3))) then
				begin
					repeat
						writeln('> Nomor rekening salah/ tidak dapat ditemukan.');
						write('> Nomor rekening : ');readln(norek);
					until ((rekbenar(norek,1)) or(rekbenar(norek,2))or(rekbenar(norek,3)))
				end;
				
				for k:=1 to arrRek.Neff do
				begin
					if (norek=arrRek.rek[k].noAkun) then
					begin
						indeksbayar:=k;
					end;
				end;
				
				writeln('> Anda dapat melakukan pembayaran :');
				writeln('> Listrik ');
				writeln('> BPJS ');
				writeln('> PDAM ');
				writeln('> Telepon ');
				writeln('> TV Kabel ');
				writeln('> Internet');
				writeln('> Kartu Kredit');
				writeln('> Pajak');
				writeln('> Pendidikan');
				writeln();
				write('> Jenis pembayaran :');readln(jenis);
				jenis:=lowercase(jenis);
				if (jenis<>'listrik') and (jenis<>'bpjs')and (jenis<>'pdam')and (jenis<>'telepon')and (jenis<>'tv kabel')and (jenis<>'internet')and (jenis<>'kartu kredit')and (jenis<>'pajak')and (jenis<>'pendidikan') then
				begin
					writeln('> Anda tidak dapat melakukan pembayaran ',jenis,' pada layanan Internet Banking')
				end else
				begin
					write('> Rekening bayar : ');readln(rekbayar);
					write('> Jumlah pembayaran: ');readln(jml);
					if not(isBolehTarik(indeksbayar,arrRek.rek[indeksbayar].jenisRek)) then
					begin
							writeln('> Akun anda tidak memenuhi ketentuan penarikan! ');
					end else
					if(isBolehTarik(indeksbayar,arrRek.rek[indeksbayar].jenisRek)) and (jml<arrRek.rek[indeksbayar].saldo) then
					begin
						writeln('> Anda akan melakukan pembayaran ',jenis);
						writeln('> Jumlah : ',jml,' ',arrRek.rek[indeksbayar].mataUang);
						writeln('> Tujuan : ',rekbayar);
						write('> Proses(y/n) : ');readln(proses);
						if(proses='y') or (proses='Y') then
						begin
							DecodeDate(date,yy,mm,dd);
							isBayar:=True;
							if(dd>15) then
							begin
								if(jenis='listrik') or (jenis='bpjs') or (jenis='pdam') or (jenis='telepon') or (jenis='tv kabel') or (jenis='internet') then
								begin
									denda:=(dd-15)*10000;
								end else
									denda:=0;
							end else
							if(dd<=15) then
							begin
								denda:=0;
							end;
						end else
						begin
							writeln('> Transaksi dibatalkan');
						end;
					end else
					if(jml>arrRek.rek[indeksbayar].saldo) then
					begin
						writeln('> Saldo Anda tidak mencukupi untuk melakukan pembayaran.');
					end;
				end;
				if(isBayar) then
				begin
					writeln('> Transaksi berhasil');
					arrRek.rek[indeksbayar].saldo:=arrRek.rek[indeksbayar].saldo-jml-convmatauang(denda,'IDR',ArrRek.rek[indeksbayar].mataUang,arrMataUang);
					if(arrBayar.Neff<Nmax) then
					begin
						arrBayar.Neff:=arrBayar.Neff+1;
					end else
					if(arrBayar.Neff=Nmax) then
					begin
						for i:=1 to Nmax-1  do    
						begin
							arrBayar.Bayar[i]:=arrBayar.Bayar[i+1];
							arrBayar.Neff:=Nmax;
						end;
					end;
					arrBayar.bayar[arrBayar.Neff].noAkun:=norek;
					arrBayar.bayar[arrBayar.Neff].jenis:=jenis;
					arrBayar.bayar[arrBayar.Neff].rekbayar:=rekbayar;
					arrBayar.bayar[arrBayar.Neff].mataUang:=arrRek.rek[indeksbayar].mataUang;
					arrBayar.bayar[arrBayar.Neff].jumlah:=jml;
					arrBayar.bayar[arrBayar.Neff].saldo:=arrRek.rek[indeksbayar].saldo;
					arrBayar.bayar[arrBayar.Neff].tglTransaksi.DD:=dd;
					arrBayar.bayar[arrBayar.Neff].tglTransaksi.MM:=mm;
					arrBayar.bayar[arrBayar.Neff].tglTransaksi.YY:=yy;
				end;
			end;
		end else
		if(not(isRekLoaded)) then
		begin
			writeln('> Data rekening belum diload');
		end else
		if(not(isBayarLoaded)) then
		begin
			writeln('> Data pembayaran belum diload');
		end else
		if(not(isLoggedin)) then
		begin
			writeln('> Silahkan login terlebih dahulu');
		end
	end;	
	
	
	
	
	function convjenisbrg(x:integer):string;
	begin
		case x of
			1:convjenisbrg:='Voucher HP';
			2:convjenisbrg:='Listrik';
			3:convjenisbrg:='Taksi Online';
		end;
	end;
	
	function convpenyedia(jenis,y:integer):string;
	begin
		if(jenis=1) then
		begin
			if(y=1) then
			begin
				convpenyedia:='Indonesia Cellular'
			end else
			if(y=2) then
			begin
				convpenyedia:='Cell-My'
			end;
		end else
		if(jenis=2) then
		begin
			if(y=1) then
			begin
				convpenyedia:='PLN'
			end;
		end else
		if(jenis=3) then
		begin
			if(y=1) then
			begin
				convpenyedia:='My-Ride'
			end;
		end;
	end;
	
	function convjumlah(a,b,y:integer):longint;
	begin
		if(convpenyedia(a,b)='Indonesia Cellular') then
		begin	
			if(y=1) then
			begin
				convjumlah:=10000;
			end else
			if(y=2) then
			begin
				convjumlah:=50000;
			end;
			if(y=3) then
			begin
				convjumlah:=100000
			end else
			if(y=4) then
			begin
				convjumlah:=1000000
			end;
		end else
		if(convpenyedia(a,b)='Cell-My') then
		begin
			if(y=1) then
			begin
				convjumlah:=100000;
			end else
			if(y=2) then
			begin
				convjumlah:=200000;
			end;
		end else
		if(convpenyedia(a,b)='PLN') then
		begin
			if(y=1) then
			begin
				convjumlah:=10000;
			end else
			if(y=2) then
			begin
				convjumlah:=50000;
			end;
			if(y=3) then
			begin
				convjumlah:=100000;
			end;
		end else
		if(convpenyedia(a,b)='My-Ride') then
		begin
			if(y=1) then
			begin
				convjumlah:=100000;
			end;
		end
	end;
		
	procedure beli;
	var
	jens,penyedia,saldodibeli,indekspembelian:integer;
	beliberhasil:boolean;
	norek,tujuan,proses:string;
	
	begin
	{Menu awal pembuatan rekening}
		if(isLoggedIn) and (isRekLoaded) and (isBeliLoaded) and (isListBarangLoaded) then
		begin
			if(not(punya(1)) and not(punya(2)) and not(punya(3))) then
			begin
				writeln('> Anda belum memiliki rekening.');
			end else
			begin
				writeln('> Silahkan masukkan nomor rekening yang akan Anda gunakan untuk pembelian');
				lihatRekening;
				write('> Nomor Rekening : ');readln(norek);
				if (not(rekbenar(norek,1)) and  not(rekbenar(norek,2)) and not (rekbenar(norek,3))) then
				begin
					repeat
						writeln('> Nomor rekening salah/ tidak dapat ditemukan.');
						write('> Nomor rekening : ');readln(norek);
					until ((rekbenar(norek,1)) or(rekbenar(norek,2))or(rekbenar(norek,3)))
				end;
				
				for k:=1 to arrRek.Neff do
				begin
					if (norek=arrRek.rek[k].noAkun) then
					begin
						indekspembelian:=k;
					end;
				end;
				
				beliberhasil:=False;
				writeln('> Pilihan jenis barang yang ingin dibeli: ');
				writeln('> 1. Voucher HP');
				writeln('> 2. Listrik');
				writeln('> 3. Taksi Online');
				write('> Jenis barang yang ingin dibeli: ');readln(jens);    {Pengambilan input dari pengguna}
				if(jens<1) or (jens>3) then
				begin
					repeat
						writeln('> Input salah. Silahkan ulangi: ');
						write('> Jenis barang yang ingin dibeli: ');readln(jens);
					until((jens>=1) and (jens<=3))
				end;
				case jens of
					1:begin 						//Voucher Hp
						writeln('> Voucher HP');
						writeln('> Pilih penyedia: ');
						writeln('> 1. Indonesia Cellular');
						writeln('> 2. Cell-My');
						write('> Pilihan : ');readln(penyedia);
						if (penyedia<1)or(penyedia>2) then
						begin
							repeat
								writeln('> Input salah. Silahkan ulangi! ');
								write('> Pilihan: ');readln(penyedia);
							until((penyedia=1) or (penyedia=2))
						end;
						if(penyedia=1) then
						begin
							writeln('> Pilih jumlah yang ingin dibeli: ');
							writeln('> 1. 10000');
							writeln('> 2. 50000');
							writeln('> 3. 100000');
							writeln('> 4. 1000000');
							write('> Pilihan: ');readln(saldodibeli);
							if (saldodibeli<1) or (saldodibeli>4) then
							repeat
								write('> Input salah. Silahkan ulangi.');
								write('> Pilihan: ');readln(saldodibeli);
							until(saldodibeli>=1)and(saldodibeli<=4);
							write('> Nomor Tujuan: ');readln(tujuan);
							if not(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
								writeln('> Akun anda tidak memenuhi ketentuan penarikan! ');
							if(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
							begin
								if(saldodibeli=1)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>10000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar ',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(10000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan.');
										end;
									end
									else writeln('> Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
								if(saldodibeli=2)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>50000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(50000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan.');
										end;
									end
									else writeln('> Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
								if(saldodibeli=3)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>100000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(100000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end
									else writeln('> Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
								if(saldodibeli=4)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>1000000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(100000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end
									else writeln('> Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
							end;
						end;
							
						if(penyedia=2) then
						begin
							writeln('> Pilih jumlah yang ingin dibeli: ');
							writeln('> 1. 100000');
							writeln('> 2. 200000');
							write('> Pilihan: ');readln(saldodibeli);
							if (saldodibeli<1) or (saldodibeli>2) then
							repeat
								writeln('> Input salah. Silahkan ulangi.');
								write('> Pilihan: ');readln(saldodibeli);
							until(saldodibeli>=1)and(saldodibeli<=2);
							write('> Nomor tujuan: ');readln(tujuan);
							if not(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
							begin	
									writeln('> Akun Anda tidak memenuhi ketentuan penarikan ');
							end else
							if(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
							begin
								if(saldodibeli=1)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>100000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(100000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end
									else writeln('Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
								if(saldodibeli=2)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>200000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(200000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end
								else writeln('Saldo anda tidak mencukupi untuk melakukan pembelian');
							end;
						end;
					end;
				end;
				  
					2:begin 						//Listrik
						writeln('> Listrik');
						writeln('> Pilih penyedia: ');
						writeln('> 1.PLN');
						write('> Pilihan: ');readln(penyedia);
						if (penyedia<1)or(penyedia>1) then
						begin
							repeat
								writeln('> Input salah. Silahkan ulangi! ');
								write('> Pilih penyedia: ');readln(penyedia);
							until(penyedia=1)
						end;
						if(penyedia=1) then
						begin
							writeln('> Pilih jumlah yang ingin dibeli: ');
							writeln('> 1.10000');
							writeln('> 2.50000');
							writeln('> 3.100000');
							write('> Pilihan: ');readln(saldodibeli);
							if (saldodibeli<1) or (saldodibeli>3) then
							repeat
								writeln('> Input salah. Silahkan ulangi');
								write('> Pilihan: ');readln(saldodibeli);
							until(saldodibeli>=1)and(saldodibeli<=3);
							write('> Nomor tujuan: ');readln(tujuan);
							if not(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
								writeln('> Akun Anda tidak memenuhi ketentuan penarikan. ');
							if(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
							begin
								if(saldodibeli=1)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>10000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(10000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end
									else writeln('> Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
								if(saldodibeli=2)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>50000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(50000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end
									else writeln('Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
								if(saldodibeli=3)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>100000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(100000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end
									else writeln('Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
							end;
						end;
					end;
				
					3:begin 						//Taksi Online
						writeln('> Taksi Online');
						writeln('> Pilih penyedia: ');
						writeln('> 1.My-Ride');
						write('> Pilihan : ');readln(penyedia);
						if (penyedia<1)or(penyedia>1) then
						begin
							repeat
								writeln('> Input salah. Silahkan ulangi! ');
								write('> Pilih penyedia: ');readln(penyedia);
							until(penyedia=1)
						end;
						if(penyedia=1) then
						begin
							writeln('> Pilih jumlah yang ingin dibeli: ');
							writeln('> 1.100000');
							write('> Pilihan: ');readln(saldodibeli);
							if (saldodibeli<>1) then
							repeat
								writeln('> Input salah. Silahkan ulangi.');
								write('> Pilihan: ');readln(saldodibeli);
							until(saldodibeli=1);
							write('> Nomor tujuan: ');readln(tujuan);
							if not(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
								writeln('> Akun anda tidak memenuhi ketentuan penarikan. ');
							if(isBolehTarik(indekspembelian,arrRek.rek[indekspembelian].jenisRek)) then
							begin
								if(saldodibeli=1)then
								begin
									if(convmatauang(ArrRek.rek[indekspembelian].saldo,ArrRek.rek[indekspembelian].mataUang,'IDR',arrMataUang)>100000) then
									begin
										writeln();
										writeln('> Anda akan melakukan pembelian ',convjenisbrg(jens),' sebesar IDR',convjumlah(jens,penyedia,saldodibeli));
										writeln('> dari ', convpenyedia(jens,penyedia));
										writeln('> Nomor Tujuan : ',tujuan);
										write('> Proses (y/n) : ');readln(proses);
										if (proses='y') or (proses='Y') then
										begin
											beliberhasil:=True;
											ArrRek.rek[indekspembelian].saldo:=ArrRek.rek[indekspembelian].saldo-convmatauang(100000,'IDR',ArrRek.rek[indekspembelian].mataUang,arrMataUang);
										end else
										begin
											writeln('> Transaksi dibatalkan');
										end;
									end else writeln('> Saldo anda tidak mencukupi untuk melakukan pembelian');
								end;
							end;
						end;
					end;
				end;
				if (beliberhasil) then
				begin
					writeln('> Transaksi pembelian berhasil');
					DecodeDate(date,yy,mm,dd);
					if(arrBeli.Neff<Nmax) then
					begin
						arrBeli.Neff:=arrBeli.Neff+1;
					end else
					if(arrBeli.Neff=Nmax) then
					begin
						for i:=1 to Nmax-1  do    
						begin
							arrBeli.Beli[i]:=arrBeli.Beli[i+1];
							arrBeli.Neff:=Nmax;
						end;
					end;
					arrBeli.beli[arrBeli.Neff].noAkun:=norek;
					arrBeli.beli[arrBeli.Neff].jenisBrg:=convjenisbrg(jens);
					arrBeli.beli[arrBeli.Neff].penyedia:=convpenyedia(jens,penyedia);
					arrBeli.beli[arrBeli.Neff].noTujuan:=tujuan;
					arrBeli.beli[arrBeli.Neff].matauang:='IDR';
					arrBeli.beli[arrBeli.Neff].jumlah:=convjumlah(jens,penyedia,saldodibeli);
					arrBeli.beli[arrBeli.Neff].saldo:=ArrRek.rek[indekspembelian].saldo;
					arrBeli.beli[arrBeli.Neff].tglTransaksi.DD:=dd;
					arrBeli.beli[arrBeli.Neff].tglTransaksi.MM:=mm;
					arrBeli.beli[arrBeli.Neff].tglTransaksi.YY:=yy;	
				end;
			end;
		end else
		if(not(isRekLoaded)) then
		begin
			writeln('> Data rekening belum diload');
		end else
		if(not(isBeliLoaded)) then
		begin
			writeln('> Data pembelian belum diload');
		end else
		if(not(isListBarangLoaded)) then
		begin
			writeln('> Data list barang pembelian belum diload');
		end else
		if(not(isLoggedin)) then
		begin
			writeln('> Silahkan login terlebih dahulu');
		end;
	end;	
			
		
	
END.
