unit accountmanagement;

interface

	uses sysutils, typeandvar,validation,datemanagement,dos,crt;
	
	var
		yy,mm,dd: word;

	{Kumpulan Fungsi & Prosedur untuk melihat data Rekening Akun}
	procedure lihatRekening;//Menampilkan semua rekening yang dimiliki oleh nasabah
	procedure informasiSaldo;//Menampilkan informasi rekening pilihan user
	function cekTanggalHistory(yangmaudicek:tanggal;waktu:integer):boolean;//Melakukan pengecekan apakah riwayat transaksi masih bisa dilihat
	{I.S waktu terdefinisi}
	{F.S menghasilkan True apabila waktu masih dalam jangka <3 bulan}
	procedure lihatriwayat;//Melihat riwayat seluruh transaksi online
	
		
		
	{Kumpulan Fungsi & Prosedur untuk Pembuatan Rekening Baru}	
	function SaldoDepositoValid(Saldo:longint;uang:integer):boolean;//Melakukan pengecekan apakah saldominimum terpenuhi
	function rentangValid(r:integer):boolean;//Melakukan pengecekan apakah rentang waktu valid
	{I.S r terdefinisi}
	{F.S menghasilkan True apabila rentang waktu yang diinputkan sesuai dengan ketentuan yang diperbolehkan}
	function convjen(jen:integer):string;//mengkonversi angka pilihan ke jenis rekening
	{I.S jen terdefinisi}
	{F.S mengubah pilihan user yang berupa integer menjadi string
	* 1=deposito
	* 2=tabungan rencana
	* 3=tabungan mandiri
	 }
	function convuang(u:integer):string;//mengkonversi angka pilihan ke jenis uang
	function genrandomstring(arr1,arr2:string):string;//generate random string untuk pembuatan nomor rekening baru
	{I.S arr1 dan arr2 terdefinisi}
	{F.S menghasilkan string sepanjang 6 karakter secara acak}
	procedure buatrekening(nas:string);//prosedur pembuatan rekening baru
	{I.S nas terdefinisi}
	procedure bikinrekening;//prosedur buatrekening yang telah divalidasi
	
	
	{Kumpulan Fungsi & Prosedur untuk Penutupan Rekening}
	function convjangka(jangka:string):integer;//mengkonversi jangka waktu dari string ke integer
	{I.S jangka terdefinisi}
	{F.S mengambil nilai integer dari jangka waktu yang berbentuk string}
	function convmatauang(awal:longint;mAwal,mAkhir:string;Ref:arrTukar):longint;//mengkonversi mata uang ke nilai mata uang lain
	{I.S awal,mAwal,mAkhir,dan Ref terdefinisi}
	{F.S menghasilkan hasil konversi berdasarkan kurs}
	function nextnmonth(n:integer;x:tanggal):integer;//menghitung bulan ke n selama jangka waktu
	{I.S n dan x terdefinisi}
	{F.S menghasilkan n bulan setelah tgl Transaksi}
	function saldotutup(reke:rekening):longint; //menghitung saldo terakhir saat penutupan rekening
	{I.S reke terdefinisi}
	{F.S menghasilkan hasil perhitungan saldo saat penutupan sesuai ketentuan}
	procedure tutupakun(var TR:ArrRekening);//prosedur untuk menutup akun
	{I.S TR terdefinisi}
	{F.S melakukan penutupan akun sesuai ketentuan}

	{Kumpulan Fungsi dan Prosedur Perubahan Data Nasabah}
	procedure perubahanDataNasabah;//prosedur untuk melakukan pengubahan data
	function CekNomorAkunKeberapa (arrRek : arrRekening; NoYangInginDiGanti : string) : Integer;
	function CekNomorAkun (arrRek : arrRekening; NoYangInginDiGanti : string) : Boolean;
	function CekNomorAkunAutodebet (arrRek : arrRekening; NomorAkunAutoDebet : string) : Boolean;
	procedure penambahanAutoDebet (var arrRek : arrRekening);//prosedur untuk melakukan penambahan autodebet;

implementation

	{SECTION informasi Rekening dan informasiSaldo}
	procedure lihatRekening;
	var
		nrek:integer;//banyaknya rekening yang telah ditemukan
	begin
		nasabahke:=findIndex(user);
		if (isLoggedIn)and(isRekloaded) then
		begin
		nrek:=0;
			for i:=1 to arrrek.Neff do
			begin
				if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)then
				begin
					nrek:=nrek+1;
					writeln('> ',nrek,'. ',arrrek.rek[i].noAkun);
				end;
			end;
			if(nrek=0) then //tidak ada rekening yang ditemukan
			begin
				writeln('> Anda belum memiliki rekening.');
			end;
		end else
		if(not(isRekloaded)) then
		begin
			writeln('> Data rekening belum diload');
			;
		end else
		if(not(isLoggedIn)) then
		begin
			writeln('> Silahkan login terlebih dahulu');
			;
		end;
	end;
	

	procedure informasiSaldo;
	var
		nrek,pil,indekstampil:integer;
		norek:string;
	begin
		nasabahke:=findIndex(user);
		if (isLoggedIn)and(isRekloaded) then
		begin
			writeln('> Pilih jenis rekening: ');
			writeln('> 1.Deposito ');
			writeln('> 2.Tabungan Rencana ');
			writeln('> 3.Tabungan Mandiri ');
			write('> Jenis rekening: ');
			readln(pil);
				if(pil=1) then //deposito
				begin
					if(punya(pil)=False) then
					begin
						writeln('> Anda tidak memiliki deposito.');
						;
					end;
					if(punya(pil)=True) then
					begin
						writeln('> Pilih rekening Deposito Anda: ');
						nrek:=0;
						for i:=1 to arrrek.Neff do
						begin
							if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='deposito') then
							begin
								nrek:=nrek+1;
								writeln('> ',nrek,'. ',arrrek.rek[i].noAkun);
							end;
						end;
						write('> Rekening deposito: ');readln(norek);
						while(not(rekbenar(norek,1))) do
						begin	
							writeln('> Nomor rekening yang Anda masukkan salah. Silahkan coba lagi.');
							write('> Rekening deposito: ');readln(norek);
							rekbenar(norek,1);
						end;
						if(rekbenar(norek,1)) then
						begin
							for j:=1 to arrrek.Neff do
							if(norek=arrrek.rek[j].noAkun) and (arrrek.rek[j].jenisRek='deposito') and (arrdata.data[nasabahke].noNasabah=arrrek.rek[j].noNasabah) then
							begin
								indekstampil:=j;
							end;
							writeln('> Nomor rekening : ',arrrek.rek[indekstampil].noAkun);
							writeln('> Tanggal Mulai : ',arrrek.rek[indekstampil].tglTransaksi.DD,'-',arrrek.rek[indekstampil].tglTransaksi.MM,'-',arrrek.rek[indekstampil].tglTransaksi.YY);
							writeln('> Mata Uang : ',arrrek.rek[indekstampil].mataUang);
							writeln('> Jangka Waktu : ',arrrek.rek[indekstampil].jangkaWaktu);
							writeln('> Setoran Rutin : ',arrrek.rek[indekstampil].setoran);
							writeln('> Saldo : ',arrrek.rek[indekstampil].saldo);
							;
						end;
					end;
				end;
				if(pil=2) then //tabungan rencana
				begin
					if(punya(pil)=False) then
					begin
						writeln('> Anda tidak mempunyai tabungan rencana ');
						;
					end;
					if(punya(pil)=True) then
					begin
						writeln('> Pilih rekening Tabungan Rencana Anda: ');
						nrek:=0;
						for i:=1 to arrrek.Neff do
						begin
							if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='tabungan rencana') then
							begin
								nrek:=nrek+1;
								writeln('> ',nrek,'. ',arrrek.rek[i].noAkun);;
							end;
						end;
						write('> Rekening tabungan rencana: ');readln(norek);
						while(not(rekbenar(norek,2))) do
						begin
							writeln('> Nomor rekening yang Anda masukkan salah. Silahkan coba lagi.');
							write('> Rekening tabungan rencana: ');readln(norek);
							rekbenar(norek,2);
						end;
						if(rekbenar(norek,2)) then
						begin
							for j:=1 to arrrek.Neff do
							begin
								if(norek=arrrek.rek[j].noAkun) and (arrrek.rek[j].jenisRek='tabungan rencana') and (arrdata.data[nasabahke].noNasabah=arrrek.rek[j].noNasabah) then
								begin
									indekstampil:=j;
								end;
							end;
							writeln('> Nomor rekening : ',arrrek.rek[indekstampil].noAkun);
							writeln('> Tanggal Mulai : ',arrrek.rek[indekstampil].tglTransaksi.DD,'-',arrrek.rek[indekstampil].tglTransaksi.MM,'-',arrrek.rek[indekstampil].tglTransaksi.YY);
							writeln('> Mata Uang : ',arrrek.rek[indekstampil].mataUang);
							writeln('> Jangka Waktu : ',arrrek.rek[indekstampil].jangkaWaktu);
							writeln('> Setoran Rutin : ',arrrek.rek[indekstampil].setoran);
							writeln('> Saldo : ',arrrek.rek[indekstampil].saldo);
							;
						end ;
					end;
				end;
				if(pil=3) then// tabungan mandiri
				begin
					if(punya(pil)=False) then
					begin
							writeln('> Anda tidak mempunyai tabungan mandiri');
							;
					end;
					if(punya(pil)=True) then
					begin
						writeln('> Pilih rekening Tabungan Mandiri Anda: ');
						nrek:=0;
						for i:=1 to arrrek.Neff do
						begin
							if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='tabungan mandiri') then
							begin
								nrek:=nrek+1;
								writeln('> ',nrek,'. ',arrrek.rek[i].noAkun);
							end;
						end;
						write('> Rekening tabungan mandiri: ');readln(norek);
						while(not(rekbenar(norek,3))) do
						begin
							writeln('> Nomor rekening yang Anda masukkan salah. Silahkan coba lagi.');
							write('> Rekening tabungan mandiri: ');readln(norek);
							rekbenar(norek,3);
						end;
						if(rekbenar(norek,3)) then
						begin
							for j:=1 to arrrek.Neff do
							begin
								if(norek=arrrek.rek[j].noAkun) and (arrrek.rek[j].jenisRek='tabungan mandiri') and (arrdata.data[nasabahke].noNasabah=arrrek.rek[j].noNasabah) then
								begin
									indekstampil:=j;
								end;
							end;
							writeln('> Nomor rekening : ',arrrek.rek[indekstampil].noAkun);
							writeln('> Tanggal Mulai : ',arrrek.rek[indekstampil].tglTransaksi.DD,'-',arrrek.rek[indekstampil].tglTransaksi.MM,'-',arrrek.rek[indekstampil].tglTransaksi.YY);
							writeln('> Mata Uang : ',arrrek.rek[indekstampil].mataUang);
							writeln('> Jangka Waktu : ',arrrek.rek[indekstampil].jangkaWaktu);
							writeln('> Setoran Rutin : ',arrrek.rek[indekstampil].setoran);
							writeln('> Saldo : ',arrrek.rek[indekstampil].saldo);
							;
						end; 
					end;
				end;
			end else	
			if(not(isRekloaded)) then
			begin
				writeln('> Data rekening belum diload');
			end else
			if(not(isLoggedIn)) then
			begin
				writeln('> Silahkan login terlebih dahulu');
			end;
	end;

	function cekTanggalHistory(yangmaudicek:tanggal;waktu:integer):boolean;
		var
			x:integer;
		begin
			GetDate(Year,Month,Day,WDay);
			thn:=Year;
			bln:=Month;
			tgl:=Day;
			x:=0;
			cekTanggalHistory:=False;
			if(yangmaudicek.YY=thn)or(yangmaudicek.YY=thn-1) then
			begin
				if (yangmaudicek.YY=thn) and ((bln-yangmaudicek.MM)<=3) and ((bln-yangmaudicek.MM)>=0) then
				begin
					x:=((bln-yangmaudicek.MM)*30)+(tgl-yangmaudicek.DD)+faktor31(yangmaudicek.MM,bln,thn);
					if(x<=waktu) or (x=0) then
					begin
						cekTanggalHistory:=True;
					end else
					begin
						cekTanggalHistory:=False;
					end;
				end else
				if (yangmaudicek.YY=thn-1) and ((bln-yangmaudicek.MM)<=-9) then
				begin
					x:=(((bln+12)-yangmaudicek.MM)*30)+(tgl-yangmaudicek.DD)+faktor31(yangmaudicek.MM,bln,thn);
					if(x<=waktu) or (x=0) then
					begin
						cekTanggalHistory:=True;
					end else
					begin
						cekTanggalHistory:=False;
					end;
				end;
			end;
		end;
					
		
		procedure lihatriwayat;
		var
			waktu:integer;
			mauliat:string;
			ada:boolean;
		begin
			if(isTransLoaded) and(isLoggedIn) and (isRekLoaded) then
			begin
				write('> Riwayat transaksi selama (hari) : ');readln(waktu);
				if(waktu<0) or (waktu>92) then
				begin
					writeln('> Anda hanya dapat melihat data transaksi selama 3 bulan terakhir.');
					repeat
						write('> Riwayat transaksi selama (hari) : ');readln(waktu);
					until((waktu>=0)and(waktu<=92))
				end else	
				if ((waktu>=1)and(waktu<=92)) then
				begin
					writeln('> Silahkan pilih rekening: ');
					lihatRekening;
					write('> Nomor rekening: ');readln(mauliat);
					if(not(rekbenar(mauliat,1)))and (not(rekbenar(mauliat,2))) and (not(rekbenar(mauliat,3))) then
					begin
						repeat
							writeln('> Input nomor rekening salah. Silahkan coba lagi: ');
							write('> Nomor rekening: ');readln(mauliat);
						until((rekbenar(mauliat,1))or (rekbenar(mauliat,2)) or (rekbenar(mauliat,3)))
					end;
					ada:=False;
					for k:=1 to Nmax do
					begin
						if(arrtrans.trans[k].noAkun=mauliat) then
						begin
							if(cekTanggalHistory(arrTrans.trans[k].tglTransaksi,waktu)) then
							begin
								ada:=True;
								writeln('> ',arrtrans.trans[k].jenisTrans,' | ',arrtrans.trans[k].noAkun, ' | ',arrtrans.trans[k].mataUang, ' | ', arrtrans.trans[k].jumlah, ' | ',arrtrans.trans[k].saldo, ' | ',arrtrans.trans[k].tglTransaksi.DD,'-',arrtrans.trans[k].tglTransaksi.MM,'-',arrtrans.trans[k].tglTransaksi.YY);
							end;
						end;
						if(arrtransf.transf[k].noAkunAsal=mauliat) then
						begin
							if(cekTanggalHistory(arrTransf.transf[k].tglTransaksi,waktu)) then
							begin
								ada:=True;
								writeln('> transfer ',arrtransf.transf[k].jenis, ' | ',arrtransf.transf[k].noAkunTujuan, ' | ',arrtransf.transf[k].mataUang, ' | ', arrtransf.transf[k].jumlah, ' | ',arrtransf.transf[k].saldo, ' | ',arrtransf.transf[k].tgltransaksi.DD,'-',arrtransf.transf[k].tgltransaksi.MM,'-',arrtransf.transf[k].tgltransaksi.YY);
							end;
						end;
						if(arrBayar.bayar[k].noAkun=mauliat) then
						begin
							if(cekTanggalHistory(arrBayar.bayar[k].tglTransaksi,waktu)) then
							begin
								ada:=True;
								writeln('> ',arrBayar.bayar[k].jenis, ' | ',arrbayar.bayar[k].rekBayar,' | ',arrbayar.bayar[k].mataUang, ' | ', arrbayar.bayar[k].jumlah, ' | ',arrbayar.bayar[k].saldo, ' | ',arrbayar.bayar[k].tglTransaksi.DD,'-',arrbayar.bayar[k].tglTransaksi.MM,'-',arrbayar.bayar[k].tglTransaksi.YY);
							end;
						end;
						if(arrBeli.beli[k].noAkun=mauliat) then
						begin
							if(cekTanggalHistory(arrBeli.beli[k].tglTransaksi,waktu)) then
							begin
								ada:=True;
								writeln('> ',arrbeli.beli[k].jenisBrg,' | ',arrbeli.beli[k].penyedia, ' | ',arrbeli.beli[k].mataUang, ' | ', arrbeli.beli[k].jumlah, ' | ',arrbeli.beli[k].saldo, ' | ',arrbeli.beli[k].tgltransaksi.DD,'-',arrbeli.beli[k].tgltransaksi.MM,'-',arrbeli.beli[k].tgltransaksi.YY);
							end;
						end;
					end;
					if(not(ada)) then
					begin
						writeln('> Tidak ada data transaksi.');
						;
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
			if(not(isLoggedin)) then
			begin
				writeln('> Silahkan login terlebih dahulu.');
			end;
		end;
	

	{SECTION Pembuatan Rekening}


	function SaldoDepositoValid(Saldo:longint;uang:integer):boolean;
	{Mengecek setoran awal untuk pembuatan rekening deposito}
	begin
		SaldoDepositoValid:=((uang=1)and(saldo>=8000000))or((uang=2)and(saldo>=600))or((uang=3)and(saldo>=550));
	end;

	function rentangValid(r:integer):boolean;
	{Mengecek rentang waktu yang valid untuk deposito}
	begin
		rentangValid:=(r=1)or(r=3)or(r=6)or(r=12);
	end;

	function convjen(jen:integer):string;
	{Mengubah bacaan jenis dalam integer pilihan pengguna ke string nama jenis rekening}
	begin
		if jen=1 then
			convjen:='deposito'
		else if jen=2 then
			convjen:='tabungan rencana'
		else 
			convjen:='tabungan mandiri';
	end;

	function convuang(u:integer):string;
	{mengubah bacaan integer pilihan mata uang ke string nama mata uang}
	begin
		if u=1 then
			convuang:='IDR'
		else if u=2 then
			convuang:='USD'
		else 
			convuang:='EUR';
	end;

	function genrandomstring(arr1,arr2:string):string;
	{menghasilkan string acak sepanjang 6 karakter dari array character yang tersedia}
	var
		arrchar: array[0..5] of char;
		i:integer;
		r:int64;
	begin
		i:=0;
		r:=random(9)+1;
		arrchar[i]:=arr2[r];
		for i:=1 to 2 do
		begin
			r:=random(25)+1;
			arrchar[i]:=arr1[r];
		end;
		for i:=3 to 5 do
		begin
			r:=random(9)+1;
			arrchar[i]:=arr2[r];
		end;
		genrandomstring:=arrchar;
	end;



	procedure buatrekening(nas:string);
	var
		jen,uang,rentang,nrek:integer; {uang: 1.IDR 2.USD 3.EUR}
		sald,setorrut: longint;
		error: Boolean; {Skema validasi yang digunakan: iterate-stop dengan not(error) sebagai kondisi stop}
		i:integer;
		random,norek,rand:string;

		
	begin
		{Inisialisasi}
		randomize;
		random:='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		randomize;
		rand:='0123456789';
		error:=false;
		setorrut:=0;
		nasabahke:=findIndex(user);
	
		{Menu awal pembuatan rekening}
		writeln('> Pilihan jenis rekening: ');
		writeln('> 1. Deposito');
		writeln('> 2. Tabungan rencana');
		writeln('> 3. Tabungan mandiri');
		write('> Jenis rekening: ');readln(jen);    {Pengambilan input dari pengguna}
		if(jen<1) or (jen>3) then
		begin
			repeat
				writeln('> Input salah. Silahkan ulangi: ');
				write('> Jenis rekening: ');readln(jen);
			until((jen>=1) and (jen<=3))
		end;
		case jen of
			1:begin 						//Deposito
				writeln('> Deposito');
				writeln('> Pilih mata uang yang digunakan');
				writeln('> 1.Rupiah (IDR)');
				writeln('> 2.Dollar (USD)');
				writeln('> 3.Euro (EUR)');
				write('> Mata uang: ') ; readln(uang);
				if (uang<1)or(uang>3) then
				begin
					repeat
						writeln('> Input salah. Silahkan ulangi! ');
						write('> Mata uang: ');readln(uang);
					until((uang>=1) and (uang<=3))
				end;
				if(uang>=1)and(uang<=3) then
					begin
						writeln('> Masukkan setoran awal deposito');
						write('> Setoran awal minimal adalah ');
						case uang of
							1:writeln('Rp8.000.000,00');
							2:writeln('USD 600');
							3:writeln('EUR 550');
						end;	 
						write('> Setoran awal: ');readln(sald);
						if not(SaldoDepositoValid(sald,uang)) then
						begin
							repeat
								writeln('> Setoran awal tidak memenuhi batas minimal. Silahkan ulangi! ');
								write('> Setoran awal: ');readln(sald);
							until(SaldoDepositoValid(sald,uang))
						end;
						if(SaldoDepositoValid(sald,uang)) then
						begin
							writeln('> Pilih rentang waktu deposito');
							writeln('> Pilihan: 1 bulan, 3 bulan, 6 bulan, 12 bulan');
							write('> Rentang waktu: '); readln(rentang);
							if not(rentangvalid(rentang)) then
							begin
								repeat
									writeln('> Rentang waktu tidak tersedia. Silahkan ulangi! ');
									write('> Rentang waktu: ');readln(rentang);
								until(rentangValid(rentang))
							end;
						end;
						if(punya(3)=True) then
						begin
							writeln('> Pilih rekening Tabungan Mandiri untuk dijadikan Autodebet: ');
							nrek:=0;
							for i:=1 to arrrek.Neff do
							begin
								if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='tabungan mandiri') then
								begin
									nrek:=nrek+1;
									writeln('> ',nrek,'. ',arrrek.rek[i].noAkun);
								end;
							end;
							write('> Rekening Autodebet: ');readln(norek);
							while(not(rekbenar(norek,3))and(norek<>'-')) do
							begin
								write('> Nomor rekening yang Anda masukkan salah. Silahkan ulangi: ');
								write('> Rekening Autodebet: ');readln(norek);
								rekbenar(norek,3);
							end;
						end else
						if (not(punya(3))) then
						begin
							writeln('> Anda tidak memiliki tabungan mandiri.');
							norek:='-';
						end;	
					end;
				end;
		  
			2:begin //Tabungan berencana
				writeln('> Tabungan Rencana');
				writeln('> Masukkan setoran awal dalam rupiah (IDR)');
				write('> Setoran awal: '); readln(sald);
				if sald<0 then
					error:=true
				else
					begin
						writeln('> Masukkan setoran rutin bulanan dalam rupiah (IDR)');
						writeln('> Setoran rutin bulanan minimal Rp500.000,00');
						write('> Setoran rutin: '); readln(setorrut);
						if (setorrut<500000) then
						begin
							repeat
								writeln('> Setoran rutin tidak memenuhi batas minimal. Silahkan ulangi! ');
								writeln('> Setoran rutin bulanan minimal Rp500.000,00');
								write('> Setoran rutin: ');readln(setorrut);
							until(setorrut>=500000)
						end;
						if (setorrut>=500000) then
						begin
							writeln('> Tentukan jangka waktu tabungan berencana dalam satuan tahun');
							writeln('> Pilihan jangka waktu dari 1 tahun sampai 20 tahun');
							write('> Jangka waktu: '); readln(rentang);							
							if (rentang>20)or(rentang<1) then
								repeat
									writeln('> Jangka waktu tidak sesuai ketentuan. Silahkan ulangi! ');
									writeln('> Pilihan jangka waktu dari 1 tahun sampai 20 tahun');
									write('> Jangka waktu: ');readln(rentang);
								until((rentang>=1)and(rentang<=20));
								uang:=1;
							end;
						end;
						if(punya(3)=True) then
						begin
							writeln('> Pilih rekening Tabungan Mandiri untuk dijadikan Autodebet: ');
							nrek:=0;
							for i:=1 to Nmax do
							begin
								if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='tabungan mandiri') then
								begin
									nrek:=nrek+1;
									writeln('> ',nrek,'. ',arrrek.rek[i].noAkun);
								end;
							end;
							write('> Rekening Autodebet: ');readln(norek);
							while(not(rekbenar(norek,3))and (norek<>'-')) do
							begin
								writeln('> Nomor rekening yang Anda masukkan salah. Silahkan ulangi: ');
								write('> Rekening Autodebet: ');readln(norek);
								rekbenar(norek,3);
							end;
						end else
						if (not(punya(3))) then
						begin
							writeln('> Anda tidak memiliki tabungan mandiri untuk rekening autodebet.');
							norek:='-';
						end;	
					end;
		
			3:begin //Mandiri
				writeln('> Tabungan mandiri');
				writeln('> Masukkan setoran awal dalam rupiah (IDR)');
				writeln('> Setoran awal minimal adalah Rp50.000,00'); 
				write('> Setoran awal: ');readln(sald);
				if sald<50000 then
				begin
					repeat
						writeln('> Setoran awal Anda tidak memenuhi batas minimum. Silahkan ulangi! ');
						write('> Setoran awal: ');readln(sald);
					until(sald>=50000);
					uang:=1;
					norek:='-';
				end;
				uang:=1;
				norek:='-';
			end else 
				error:=true;  
			end;
	if error then
	begin	
		writeln('> Terjadi kesalahan, silahkan coba lagi.');
	end	
	else
		begin
			writeln('> Pembuatan rekening berhasil');
	
			{pemasukan input ke array, setelah semua input dipastikan valid}
			DeCodeDate(Date,yy,mm,dd);
			if (arrrek.Neff<NMax) then
			begin
				arrrek.Neff:=arrrek.Neff+1;
				i:=arrrek.Neff;
				arrrek.rek[i].noAkun:=genrandomstring(random,rand);
				arrrek.rek[i].noNasabah:=nas;
				arrrek.rek[i].jenisRek:=convjen(jen);
				writeln('> Jenis rekening baru Anda: ',arrrek.rek[i].jenisRek);
				writeln('> Nomor rekening baru Anda: ',arrrek.rek[i].noAkun);
				arrrek.rek[i].mataUang:=convuang(uang);
				arrrek.rek[i].saldo:=sald;
				arrrek.rek[i].setoran:=setorrut;
				arrrek.rek[i].rekAutodebet:=norek;
			end;
		
			if jen=1 then
			begin 
				arrrek.rek[i].jangkaWaktu:=format('%d bulan',[rentang]);
			end else
			if jen=2 then 
			begin
				arrrek.rek[i].jangkaWaktu:=format('%d tahun',[rentang]);
			end else
			begin
				arrrek.rek[i].jangkaWaktu:='-';
			end;
				arrrek.rek[i].tglTransaksi.DD:=dd;
				arrrek.rek[i].tglTransaksi.MM:=mm;
				arrrek.rek[i].tglTransaksi.YY:=yy;
		end;
	end;		

	procedure bikinrekening;
	BEGIN
		nasabahke:=findIndex(user);
		if(isLoggedIn) and (isRekLoaded)and(isDataLoaded) then
		begin
			if(arrrek.Neff<Nmax) then
			begin
				BuatRekening(arrdata.data[nasabahke].noNasabah);
			end else
			if(arrRek.Neff=Nmax) then
			begin
				writeln('> Database penuh. Pembuatan rekening gagal.');
			end;
		end else
		if (not(isLoggedIn))then
		begin
			writeln('> Silahkan login terlebih dahulu');
		end else
		if (not(isDataLoaded)) then
		begin
			writeln('> Data nasabah belum diload');
		end else
		if (not(isRekLoaded)) then
		begin
			writeln('> Data rekening belum diload');
		end;
	END;

	{SECTION Penutupan Rekening}

	function convjangka(jangka:string):integer;
	{mengonversi jangka waktu dari string ke integer}
	var
		i,j:integer;
		jang:string;
	begin
		jang:='';
		i:=1;
		while jangka[i]<>' ' do
			i:=i+1;
		for j:=1 to (i-1) do
			jang:=jang+jangka[j];
		convjangka:=StrToInt(jang);
	end;
	
	function convmatauang(awal:longint;mAwal,mAkhir:string;Ref:arrTukar):longint;
	{Mengonversi mata uang dari mAwal ke mAkhir menggunakan referensi nilai tukar dari array nilai tukar}
	 var
		i:integer;
	
	begin
		convmatauang:=awal;
		for i:=1 to Ref.Neff do
			if (Ref.tukarUang[i].kursAsal=mAwal)and(Ref.tukarUang[i].kursTujuan=mAkhir) then
				begin
					convmatauang:=round((awal/ref.tukarUang[i].nKursAsal)*ref.tukarUang[i].nKursTujuan);
				end
			else if (Ref.tukarUang[i].kursAsal=mAkhir)and(Ref.tukarUang[i].kursTujuan=mAwal) then
				convmatauang:=round((awal/(ref.tukarUang[i].nKursTujuan))*ref.tukarUang[i].nKursAsal);	
	end;
	
	function nextnmonth(n:integer;x:tanggal):integer;
	begin
		if(x.MM+n<=12) then
		begin	
			nextnmonth:=x.MM+n;
		end else
			nextnmonth:=x.MM+n-12
	end;
	
	function saldotutup(reke:rekening):longint;
	{menghitung saldo rekening yang ditutup setelah dikurangi biaya penutupan dan penalti,
	* Mata uang yang digunakan dalam hasil adalah rupiah (IDR), mata uang lain akan dikonversi ke rupiah}
	var
		yy,mm,dd:word;
		penaltiDeposito:longint;
		
	begin
		DecodeDate(date,yy,mm,dd);
		if (reke.jenisRek='tabungan mandiri') then
		begin
			saldotutup:=(convmatauang(reke.saldo,reke.mataUang,'IDR',arrMataUang)-25000)
		end else 
		if (reke.jenisRek='tabungan rencana') then
		begin
			if((convjangka(reke.jangkaWaktu))*30-(yy-reke.tglTransaksi.YY)*365-(mm-reke.tglTransaksi.MM)*30-(dd-reke.tglTransaksi.DD)>0) then
			begin
				saldotutup:=(convmatauang(reke.saldo,reke.mataUang,'IDR',arrMataUang)-225000)
			end else
			begin
				saldotutup:=(convmatauang(reke.saldo,reke.mataUang,'IDR',arrMataUang)-25000)
			end
		end else {deposito}
			if((convjangka(reke.jangkaWaktu))*30-(yy-reke.tglTransaksi.YY)*365-(mm-reke.tglTransaksi.MM)*30-(dd-reke.tglTransaksi.DD)>0) then
			begin
				if(reke.tglTransaksi.DD=31) and (is31(nextnmonth(convjangka(reke.jangkaWaktu),reke.tglTransaksi))=False) then
				begin
					penaltiDeposito:=((convjangka(reke.jangkaWaktu))*30 + faktor31(mm,nextnmonth(convjangka(reke.jangkaWaktu),reke.tglTransaksi),yy)-(yy-reke.tglTransaksi.YY)*365-(mm-reke.tglTransaksi.MM)*30-(dd+1-reke.tglTransaksi.DD))*10000;
				end else
				begin
					penaltiDeposito:=((convjangka(reke.jangkaWaktu))*30 + faktor31(mm,nextnmonth(convjangka(reke.jangkaWaktu),reke.tglTransaksi),yy)-(yy-reke.tglTransaksi.YY)*365-(mm-reke.tglTransaksi.MM)*30-(dd-reke.tglTransaksi.DD))*10000
				end;
				saldotutup:=(convmatauang(reke.saldo,reke.mataUang,'IDR',arrMatauang)-(25000+penaltiDeposito));
			end else
			begin
				saldotutup:=(convmatauang(reke.saldo,reke.mataUang,'IDR',arrMatauang)-25000);
			end;
		end;
	
	
	procedure tutupakun(var TR:ArrRekening);
	//KAMUS LOKAL
	var
		i,j,m,N,x:integer; {i=indeks universal, j=Neff untuk indeksakun, N=pilihan pengguna, x=indeks rekening yang akan dihapus}
		indeksakun:array[1..Nmax] of integer; {array untuk menyimpan indeks semua rekening milik pengguna dalam array rekening}
		saltrans:longint;
		 
	begin
		if((isLoggedIn) and (isRekLoaded) and (isDataLoaded) and (isMataUangLoaded)) then
		begin
			for i:=1 to Nmax do
			begin
				indeksakun[i]:=0;
			end;
			nasabahke:=findIndex(user);
			if ((not(punya(1))) and (not(punya(2))) and (not(punya(3)))) then
			begin
				writeln('> Maaf, Anda tidak memiliki rekening untuk ditutup.');
				; 
			end else	{nasabah memiliki rekening terdaftar}
			begin
				writeln('> Pilih rekening yang akan ditutup');
				j:=0; 
				for i:=1 to TR.Neff do								
					if TR.rek[i].noNasabah=arrdata.data[nasabahke].noNasabah then   {mencari rekening yang dimiliki nasabah}	
					begin
						j:=j+1;  
						indeksakun[j]:=i;   {menyimpan indeks arrRekening untuk semua rekening nasabah}
						writeln('> ',j,'. ',TR.rek[i].jenisRek,' dengan nomor akun ',TR.rek[i].noAkun); {menampilkan pilihan rekening ke layar}
					end;
					write('> Pilihan: '); readln(N);
					if (N>j) or (N<0) then
						repeat
							writeln('> Pilihan tidak valid');
							write('> Pilihan: '); readln(N);
						until (N<=j)and(N>0)	{Validasi pilihan}
					else
					begin
						x:=indeksakun[N];
						if saldotutup(TR.rek[x])<0 then     {pengecekan saldo rekening yang akan ditutup}
							writeln('> Saldo tidak mencukupi untuk menutup rekening')
						else
							begin
								writeln('> Pilih apa yang ingin anda lakukan terhadap sisa saldo');
								writeln('> 1. Pindahkan ke rekening lain');
								writeln('> 2. Tarik tunai');
								write('> Pilihan: '); readln(N);
								if (N>2)or(N<1) then					{Validasi pilihan}
									writeln('> Pilihan tidak valid')		
								else 
								 begin
									if N=2 then
									begin	
										writeln('> Sisa saldo Anda : ',saldotutup(TR.rek[x]));
										writeln('> Silakan ambil sisa saldo anda, rekening telah ditutup')
									end else {n=1}
										if j=1 then {pengguna hanya memiliki satu rekening, yaitu yang sedang diproses penutupannya} 
											begin
												writeln('> Anda tidak memiliki rekening lain untuk memindahkan saldo');
												writeln('> Sisa saldo Anda : ',saldotutup(TR.rek[x]));
												writeln('> Silakan ambil sisa saldo Anda, rekening telah ditutup');
											end
										else {j>1, pengguna memiliki rekening lain untuk mentransfer sisa saldo}
											begin
												writeln('> Pilih rekening untuk memindahkan saldo');
											
												{menampilkan rekening milik pengguna selain rekening yang akan ditutup}
												for i:=1 to j do
													if indeksakun[i]<x then
														writeln('> ',i,'. ',TR.rek[indeksakun[i]].jenisRek,' dengan nomor akun ',TR.rek[indeksakun[i]].noAkun) 
													else if indeksakun[i]>x then
														writeln('> ',(i-1),'. ',TR.rek[indeksakun[i]].jenisRek,' dengan nomor akun ',TR.rek[indeksakun[i]].noAkun);
												write('> Pilihan: ');readln(N);
												if indeksakun[N]=x then N:=N+1; {koreksi untuk pilihan yang ditampilkan}
												
												{Pengalihan saldo ke rekening lain, sesuai mata uang yang digunakan pada rekening tersebut}
												m:=indeksakun[N];
												saltrans:=convmatauang(saldotutup(TR.rek[x]),'IDR',TR.rek[m].mataUang,arrMatauang);
												TR.rek[m].saldo:=TR.rek[m].saldo+saltrans;
												writeln('> Saldo berhasil dipindahkan, penutupan rekening berhasil');
												;				
											end;
								if TR.rek[x].jenisrek='tabungan mandiri' then
									begin
										for i:=1 to TR.Neff do
										begin
											if(TR.rek[i].rekAutodebet=TR.rek[x].noAkun) then
											begin
												TR.rek[i].rekAutodebet:='-';
											end;
										end;
									end;
												
							
								{setelah saldo dipindahkan, rekening dihapus dari array}
								TR.Neff:=TR.Neff-1;{panjang array rekening berkurang satu}
								for i:=x to TR.Neff  do    
										TR.rek[i]:=TR.rek[i+1];  {semua rekening setelah rekening yang dihapus digeser satu indeks}
								end;
							end;			
					end;
				end;
			end else
			if(not(isRekLoaded)) or (not(isDataLoaded)) or (not(isMataUangLoaded)) then
			begin
				writeln('> Silahkan load data terlebih dahulu.');
			end else
			if(not(isLoggedin)) then
			begin
				writeln('> Silahkan login terlebih dahulu.');
			end;
		end;

	{SECTION perubahanData}

	procedure perubahanDataNasabah;
	//KAMUS LOKAL
	var
	Pilihan: integer;
	kebenaranPilihan:boolean;
	temp: string;
	ch:char;
	
	begin
		if(isLoggedIn)and(isDataLoaded) then
		begin
			nasabahke:=findIndex(user);
			writeln('> Pilih data yang ingin diubah : ');
			writeln('> 1. Nama Nasabah');
			writeln('> 2. Alamat');
			writeln('> 3. Kota');
			writeln('> 4. Email');
			writeln('> 5. Nomor Telepon');
			writeln('> 6. Password');
			{user menginput pilihannya}
			write('> Masukkan pilihan: ');readln(Pilihan);
			{sesuai dengan pilihan}
			kebenaranPilihan:=True;
			if (pilihan<1) or (pilihan>6) then
			begin	
				kebenaranPilihan:=False;
			end;
			
			if (not(kebenaranPilihan)) then
			begin
				repeat
					writeln('> Pilihan yang anda masukan salah, mohon masukan angka 1-6: ');
					write('> Masukkan pilihan: ');readln(pilihan);
					if (pilihan<1) or (pilihan>6) then
					begin	
						kebenaranPilihan:=False;
					end else
					begin
						kebenaranPilihan:=True;
					end;
				until(kebenaranPilihan);
			end;
			if(kebenaranPilihan) then
			begin
				case Pilihan of
					1 : begin
							writeln('> Masukan nama nasabah yang baru');
							write('> ');readln(temp);
							arrData.data[nasabahke].nama:=temp;
							writeln('> Data berhasil diganti!');
							;
						end;	
					2 : begin
							writeln('> Masukan alamat nasabah yang baru: ');
							write('> ');readln(temp);
							arrData.data[nasabahke].alamat:=temp;
							writeln('> Data berhasil diganti!');
							;
						end;
					3 : begin
							writeln('> Masukan kota nasabah yang baru: ');
							write('> ');readln(temp);
							arrData.data[nasabahke].kota:=temp;
							writeln('> Data berhasil diganti!');
							;
						end;
					4 : begin
							writeln('> Masukan email nasabah yang baru: ' );
							write('> ');readln(temp);
							arrData.data[nasabahke].email:=temp;
							writeln('> Data berhasil diganti!');
							;
						end;
					5 : begin
							writeln('> Masukan nomor telepon nasabah yang baru: ');
							write('> ');readln(temp);
							arrData.data[nasabahke].noTelp:=temp;
							writeln('> Data berhasil diganti!');
							;
						end;
					6 : begin
							write('> Masukkan password lama: ');
							pass:='';
							ch := readkey; 
							while ch <> #13 do 
							begin 
								pass := pass + ch; 
								ch := readkey 
							end;	
							writeln();
							if arrdata.data[nasabahke].password=pass then
							begin
								write('> Masukan password nasabah yang baru: ');
								temp:='';
								ch:=readkey;
								while ch <> #13 do 
								begin
									temp := temp + ch; 
									ch := readkey 
								end;	
								writeln();
								write('> Konfirmasi password baru: ');
								pass:='';
								ch:=readkey;
								while ch <> #13 do 
								begin 
									pass := pass + ch; 
									ch := readkey 
								end;	
								if(pass=temp) then
								begin
									arrData.data[nasabahke].password:=temp;
									writeln();
									writeln('> Data berhasil diganti!');
								end else
								begin
									writeln();
									writeln('> Konfirmasi gagal. Pastikan password sama.');
								end;
							end else
							begin
								writeln('> Password salah.');
							end;
						end ;
					end;
				end;		
			end else
			if(not(isDataLoaded)) then
			begin
				writeln('> Data nasabah belum diload.');
				;
			end else
			if(not(isLoggedIn)) then
			begin
				writeln('> Silahkan login terlebih dahulu.');
				;
			end;
		end;
	
	function CekNomorAkunKeberapa (arrRek : arrRekening; NoYangInginDiGanti : string) : Integer;
	{Cek Nomor Akun ke berapakah nomor akun yang ingin diganti ini}
	var 
		i: integer;
		KebenaranCek:boolean;
	begin
		i:=1;
		KebenaranCek:=False;
		repeat
			if (NoYangInginDiGanti = arrRek.rek[i].noAkun) then
			begin
				KebenaranCek:=True;
			end else
			begin
				i:=i+1;
			end;
		until ((KebenaranCek) or (i>arrRek.Neff));
		CekNomorAkunKeberapa:=i;
	end;
	
	
	function CekNomorAkun (arrRek : arrRekening; NoYangInginDiGanti : string) : Boolean;
	{Cek apakah nomor akun yang ingin diganti terdapat didalam sistem}
	var 
		i : integer;
		KebenaranCek:boolean;
	begin
		KebenaranCek:=False;
		nasabahke:=FindIndex(user);
		i:=1;
		repeat
			if (NoYangInginDiGanti = arrRek.rek[i].noAkun) and (arrRek.rek[i].noNasabah=arrdata.data[nasabahke].noNasabah) then
			begin
				KebenaranCek:=True;
			end else
			begin
				i:=i+1;
			end;
		until ((KebenaranCek) or (i>arrRek.Neff));
		if (not(KebenaranCek)) then
		begin
			CekNomorAkun:=False;
		end else
		begin
			CekNomorAkun:=True;
		end;
	end;
	
	
	function CekNomorAkunAutodebet (arrRek : arrRekening; NomorAkunAutoDebet : string) : Boolean;
	{Cek apakah nomor akun autodebet yang dimasukan terdapat di dalam sistem dan adalah rekening mandiri}
	var 
		i: integer;
		KebenaranCek:boolean;
	begin
		KebenaranCek:=False;
		i:=1;
		repeat
			if ((NomorAkunAutoDebet = arrRek.rek[i].noAkun) and (arrRek.rek[i].jenisRek= 'tabungan mandiri')) then
			begin
				KebenaranCek:=True;
			end else
			begin
				i:=i+1;
			end;
		until ((KebenaranCek) or (i>arrRek.Neff));
		if (KebenaranCek=False) then
		begin
			CekNomorAkunAutodebet:=False;
		end else
		begin
			CekNomorAkunAutodebet:=True;
		end;
	end;
	
	procedure penambahanAutoDebet (var arrRek : arrRekening);
	{
	* F14-penambahanAutoDebet: mengubah/menambahkan rekening autodebet untuk rekening jenis 
	* deposito dan tabungan rencana dari salah satu rekening tabungan mandiri (jika ada).
	}
	var
		NoAkunYangInginDiganti, NomorAkunAutodebet,pil : string;
		NomorAkunKe,i,nasabahke:integer;
	begin
		nasabahke:=findIndex(user);
		if(isLoggedIn) and (isRekLoaded) and (isDataLoaded) then
		begin
			if ((not(punya(1))) and (not(punya(2)))) then
			begin
				writeln('> Maaf, Anda tidak memiliki rekening deposito atau tabungan berencana..'); 
			end else
			begin
				writeln('> Pilih rekening yang akan ditambahkan rekening autodebet :');
				j:=0; 
				for i:=1 to arrRek.Neff do								
				begin	
					if (arrRek.rek[i].noNasabah=arrdata.data[nasabahke].noNasabah) and (arrRek.rek[i].jenisRek<>'tabungan mandiri') then   {mencari rekening yang dimiliki nasabah}	
					begin
						writeln('> ',arrRek.rek[i].jenisRek,' | ',arrRek.rek[i].noAkun); {menampilkan pilihan rekening ke layar}
					end;
				end;
				write('> Masukkan Nomor Rekening: ');readln(NoAkunYangInginDiganti);
				{Check apakah NoAkunYangInginDiganti adalah rekening berjenis deposito/tabungan rencana}
				while (CekNomorAkun(arrRek, NoAkunYangInginDiGanti)=False) do
				begin
					write('> Nomor akun yang anda masukkan tidak terdapat di sistem.');
					readln(NoAkunYangInginDiGanti);
				end;
				NomorAkunKe := CekNomorAkunKeberapa(arrRek, NoAkunYangInginDiGanti);
			end;
			{Ketika nomor akun yang dimasukkan sudah benar}
			if(not(punya(3))) then
			begin
				writeln('> Maaf Anda tidak mempunyai tabungan mandiri untuk dijadikan rekening autodebet.');
			end else
			begin
				writeln('> Daftar rekening mandiri untuk dijadikan autodebet');
				for i:=1 to arrRek.Neff do								
				begin
					if (arrRek.rek[i].noNasabah=arrdata.data[nasabahke].noNasabah) and (arrRek.rek[i].jenisRek='tabungan mandiri') then   {mencari rekening yang dimiliki nasabah}	
					begin
						writeln('> ',arrRek.rek[i].noAkun,' | ', arrRek.rek[i].saldo); {menampilkan pilihan rekening ke layar}
					end;
				end;
				write('> Masukkan nomor rekening yang ingin dijadikan rekening autodebet: ');readln(NomorAkunAutodebet);
				{Cek apakah nomor akun yang ingin dijadikan akun autodebet ini ada dan adalah rekening mandiri}
				while ( CekNomorAkunAutodebet(arrRek, NomorAkunAutoDebet) = False ) do
				begin
					writeln('> Nomor akun yang anda masukkan tidak terdapat di sistem:');
					write('> Silahkan masukkan nomor rekening: ');readln(NomorAkunAutoDebet);
				end;
				{Jika sudah berhasil dimasuka nomor akun autodebet yang benar}
				if(arrRek.rek[NomorAkunke].rekAutodebet='-') then
				begin
					arrRek.rek[NomorAkunke].rekAutodebet:=NomorAkunAutodebet;
					writeln('> Nomor rekening autodebet berhasil ditambahkan ');
				end else
				if(arrRek.rek[NomorAkunke].rekAutodebet<>'-') then
				begin
					if(NomorAkunAutodebet=arrRek.rek[NomorAkunke].rekAutodebet) then
					begin
						writeln('> Nomor rekening ', NomorAkunAutodebet,' sudah terdaftar sebagai rekening autodebet');
					end else
					begin
						writeln('> Rekening dengan nomor ', arrRek.rek[NomorAkunke].noAkun, ' sudah memiliki rekening deposito terdaftar');
						writeln('> Apakah Anda ingin mengganti ', arrRek.rek[NomorAkunke].rekAutodebet, ' dengan ',NomorAkunAutodebet,' ?');
						write('> y/n : ');readln(pil);
						if(pil='y') or (pil='Y') then
						begin
							arrRek.rek[NomorAkunke].rekAutodebet:=NomorAkunAutodebet;
							writeln('> Nomor rekening autodebet berhasil diubah ');
						end;
					end;
				end;
			end;
		end else
			if (not(isDataLoaded)) and not(isRekLoaded) then
			begin
				writeln('> Silahkan load data terlebih dahulu.');
			end else
			if(not(isLoggedin)) then
			begin
				writeln('> Silahkan login terlebih dahulu');
			end;
		end;
		
			

END.
