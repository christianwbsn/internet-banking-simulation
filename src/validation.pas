unit validation;
//Spesifikasi: unit untuk melakukan pengecekan apakah load berhasil dilakukan oleh user dan nama file ditemukan
//Unit ini berguna untuk memvalidasi input yang diberikan oleh user saat melakukan aktivitas dalam program

interface

	uses sysutils, typeandvar,filemanagement, dos,crt,datemanagement;
	
	//KAMUS GLOBAL
	var
	nasabahke,tgl,bln,thn,hri:integer;
	
	{Kumpulan fungsi dan prosedur untuk memvalidasi perintah yang diberikan user}
	function checkerrorCommand(x:string):boolean;//mengecek apakah input user benar
	{I.S x terdefinisi}
	{F.S menghasilkan True apabila perintah user sesuai}
	procedure validateCommand;//menampilkan pesan error apabila input salah
	
	
	{Kumpulan fungsi dan prosedur untuk memvalidasi load yang dilakukan oleh user}
	function checkerrorLoad (x:string):boolean;//mengecek apakah file yang diload benar dan tersedia
	{I.S x tedefinisi}
	{F.S menghasilkan true apabila nama file yang diload benar}
	function doubleload(namafile:string):boolean;//mengecek supaya tidak ada file yang diload 2 kali
	{I.S namafile terdefinisi}
	{F.S menghasilkan true apabila file eksternal sudah pernah diload dan loading berhasil}
	procedure validateLoad;//memvalidasi load dan menampilkan pesan error apabila salah
	{I.S DataFile eksternal terdefinisi, Array terdefinisi}
	{F.S Data dalam file eksternal dipindahkan dalam struktur penyimpanan internal array}
	
	
	{Kumpulan fungsi dan prosedur untuk memvalidasi login user}
	function checkerrorUsername(x:string):boolean;//mengecek apakah username tersedia dalam penyimpanan
	function doublesignin(command:string):boolean;//memastikan tidak terjadi dua kali sign in
	function findIndex(x:string):integer;//mencari index dalam array untuk no nasabah dari user yang login
	procedure validateUser;//melakukan validasi input nama user dan paswword
	procedure login;
	{I.S data nasabah sudah terload, username dan pass terdefinisi}
	{F.S user berhasil sign in}
	procedure logout;

	function punya(pil:integer):boolean;//mengecek apakah user mempunyai rekening deposito,tabungan rencana, atau tabungan mandiri
	{I.S pilihan terdefinisi >1 <=3}
	{F.S menghasilkan True apabila user memiliki akun dengan jenis sesuai pilihan}
	function rekbenar(norek:string;x:integer):boolean;//mengecek apakah nomor rekening dimiliki oleh user dan jenis rekeningnya sesuai
	{I.S norek terdefinisi dan x terdefinisi}
	{F.S menghasilkan true apabila norek sesuai dengan kepemilikan user dan sesuai dengan jenis rekeningnya}
	
	procedure help;
	
implementation
	
	{SECTION Validasi Command}
	
	function checkerrorCommand(x:string):boolean;
	begin
		if ((x<>c1) and(x<>'lihat rekening') and (x<>'informasi saldo') and (x<>'lihat aktivitas transaksi') and (x<>'pembuatan rekening') and (x<>'penutupan rekening') and (x<>'perubahan data nasabah') and (x<>'penambahan autodebet') and (x<>c2)and (x<>c25) and (x<>c3) and (x<>c4) and (x<>c5) and (x<>c6) and (x<>c7) and (x<>c8) and (x<>c9) and (x<>c10) and (x<>c11) and (x<>c12) and (x<>c13) and (x<>c14) and (x<>c15) and(x<>'help')) then
		begin
			checkerrorCommand:= False
		end;
	end;

	
	procedure validateCommand;
	begin
		write('> ');readln(command);
		command:=lowercase(command);
		if(checkerrorCommand(command)=False) then
		begin
			writeln('> Perintah ','"',command,'"',' tidak tersedia dalam layanan Internet Banking');
			writeln('> Untuk melihat daftar perintah silahkan ketik "help"');
			writeln();
		end;
	end;
	
	{SECTION validasi load}

	function checkerrorLoad(x:string):boolean;
	begin
		if ((x<>f1) and (x<>f2) and (x<>f3) and (x<>f4) and (x<>f5) and (x<>f6) and (x<>f7) and (x<>f8) and(x<>'all')) then
		begin
			checkerrorLoad:= False
		end;
	end;
	
	
	function doubleload(namafile:string):boolean;
	begin
		doubleload:=False;
		if(((isRekloaded)and(namafile='rekening.txt')) or 
		((isDataLoaded)and(namafile='nasabah.txt'))or 
		((isTransLoaded)and(namafile='transaksi.txt'))or
		((isTransfLoaded)and(namafile='transfer.txt'))or
		((isBayarLoaded) and(namafile='pembayaran.txt'))or 
		((isBeliLoaded) and(namafile='pembelian.txt'))or
		((isMataUangLoaded)and(namafile='tukarmatauang.txt'))or
		((isListBarangLoaded)and(namafile='listbarang.txt'))) then
		begin
			doubleload:= True;
		end;
	end;
	
	
	procedure validateLoad;
	begin
		repeat
			write('> Nama file : ');readln(namafile);
			isNasabahKosong:=False;
			if(checkerrorLoad(namafile)=True) and (doubleload(namafile)=False) then
			begin
				loading(namafile);
				if(not(isNasabahKosong)) and (not(isError)) and (not(isListBarangKosong)) and (not(isMataUangKosong)) then
				begin
					writeln('> Pembacaan file berhasil !');
				end else
				if(isNasabahKosong) then
				begin
					command:='exit';
				end;
			end else
			if(checkerrorLoad(namafile)=False) then
			begin
				writeln('> File "',namafile,'" tidak dapat ditemukan');
			end else
			if (doubleload(namafile)=True) then
			begin
				writeln('> Data "',namafile,'" telah diload.');
			end;
		until ((checkerrorLoad(namafile)=True) or (isNasabahKosong=True) or (isError=True) or (isMataUangkosong) or (isListBarangKosong))
	end;	
	
	
	{SECTION validasi login}

	function checkerrorUsername(x:string):boolean;
	//KAMUS LOKAL
	var
		isFound:boolean;
	begin
		i:=1;
		isFound:=False;
		while ((i<Nmax)and(isFound=False)) do
		begin
			if (x=arrdata.data[i].username) then
			begin
				checkerrorUsername:=True;
				isFound:=True;
			end else
				checkerrorUsername:=False;
			i:=i+1;
		end;
	end;
	
	
	function doublesignin(command:string):boolean;
	begin
		doublesignin:=False;
		if(isLoggedin=True)and(command='login') then
		begin
			doublesignin:=True
		end else
		begin
			doublesignin:=False;
		end;
	end;	
		
	function findIndex(x:string):integer;
	begin
		for i:=1 to arrdata.Neff do
		begin
			if(x=arrdata.data[i].username) then
			begin
				findIndex:=i;
			end;
		end;
	end;
	
	procedure validateUser;
	//KAMUS LOKAL
	var
		n:integer;
		ch:char;
		checkPass:boolean;
	begin
		write('> Username: ');readln(user);
		write('> Password: ');
		ch := readkey; 
		while ch <> #13 do 
		begin 
			pass := pass + ch; 
			ch := readkey 
		end;	
		writeln();
		if(checkerrorUsername(user)=True) then
		begin
			nasabahke:=findIndex(user);
		end;
		if(checkerrorUsername(user)=False)then
		begin
			writeln('> Nasabah dengan username ','"',user,'"',' tidak ditemukan ');
		end else 
		if(checkerrorUsername(user)=True)and(doublesignin(command)=False)then
		begin
			nasabahke:=findIndex(user);
			if(pass=arrdata.data[nasabahke].password) then
			begin
				if(arrdata.data[nasabahke].status='inaktif') then
				begin
					writeln('> Status nasabah Anda inaktif.');
					writeln('> Silahkan hubungi kantor cabang terdekat untuk mengaktifkan kembali akun Anda');
				end else
				if(arrdata.data[nasabahke].status='aktif') then
				begin
					checkPass:=True;
					writeln('> Login berhasil, Selamat Datang ',arrdata.data[nasabahke].nama, ' !');
					GetDate(Year,Month,Day,WDay);
					isLoggedIn:=True;
				end;
			end else
			if(pass<>arrdata.data[nasabahke].password) then
			begin
				checkPass:=False;
				n:=1;
				while((n<3) and (not(checkPass)) and (checkerrorUsername(user))) do
				begin
					writeln('> Password tidak tepat. Silahkan coba lagi. Anda hanya memiliki ',3-n);
					writeln('kesempatan lagi');
					writeln();
					write('> Username: ');readln(user);
					write('> Password: ');
					ch := readkey; 
					pass:='';
					while ch <> #13 do 
					begin 
						pass := pass + ch; 
						ch := readkey 
					end;
					if(user=arrdata.data[nasabahke].username) then
					begin
						n:=n+1;
					end else
					begin
						n:=1;
					end;
					writeln();
					if(not(checkerrorUsername(user))) then
					begin
						writeln('> Nasabah dengan username ','"',user,'"',' tidak ditemukan ');
					end else
					begin
					nasabahke:=findIndex(user);
						if(pass=arrdata.data[nasabahke].password)and(arrdata.data[nasabahke].status='aktif') then
						begin
							checkPass:=True;
							writeln('> Login berhasil, Selamat datang ',arrdata.data[nasabahke].nama, ' !');
							GetDate(Year,Month,Day,WDay);
							isLoggedIn:=True;
						end;
						if(arrdata.data[nasabahke].status='inaktif') then
						begin
							checkPass:=True;
							writeln('> Status nasabah Anda inaktif.');
							writeln('> Silahkan hubungi kantor cabang terdekat untuk mengaktifkan kembali akun Anda');
						end;
					end;
				end;
				if(n=3)and(checkPass=False) then
				begin
					writeln('> Status akun Anda diinaktifkan. ');
					arrdata.data[nasabahke].status:='inaktif';
				end;
			end;
		end;
	end;
	
	procedure login;
	begin
		if(isDataLoaded=False) or(isKosong) then
		begin
			writeln('> Data nasabah belum diload atau kosong');	
		end else
		begin
			if(not(doublesignin(command))) then
			begin
				validateUser;
			end else
			begin
				writeln('> Anda telah login sebagai ',arrData.data[findIndex(user)].nama);
			end;	
		end;
	end;
	
	procedure logout;
	begin
		if(isLoggedIn) then 
		begin
			isLoggedIn:=False;
			user:='';
			nasabahke:=0;
			writeln('> Anda berhasil logout');
		end else
		begin
			writeln('> Anda belum login');
		end;
	end;
	
	{SECTION Cek Kepemilikan Rekening oleh user yang login}
		
	function punya(pil:integer):boolean;
	begin
		nasabahke:=FindIndex(user);
		punya:=False;
		if (pil=1) then
		begin
			for i:=1 to arrrek.Neff do
			begin
				if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='deposito') then
				begin
					punya:=True;
				end;
			end;
		end;
		if (pil=2) then
		begin
			for i:=1 to arrrek.Neff do
			begin
				if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='tabungan rencana') then
				begin
					punya:=True;
				end;
			end;
		end;
		if (pil=3) then
		begin
			for i:=1 to arrrek.Neff do
			begin
				if (arrdata.data[nasabahke].noNasabah=arrrek.rek[i].noNasabah)and(arrrek.rek[i].jenisRek='tabungan mandiri') then
				begin
					punya:=True;
				end;
			end;
		end;
	end;
	
	
	function rekbenar(norek:string;x:integer):boolean;
	begin
		rekbenar:=False;
		if(x=1) then
		begin
			for j:=1 to arrrek.Neff do
			begin
				if(norek=arrrek.rek[j].noAkun) and (arrrek.rek[j].jenisRek='deposito') and (arrdata.data[nasabahke].noNasabah=arrrek.rek[j].noNasabah) then
				begin
					rekbenar:=True;
				end;
			end;
		end else
		if(x=2) then
		begin
			for j:=1 to arrrek.Neff do
			begin
				if(norek=arrrek.rek[j].noAkun) and (arrrek.rek[j].jenisRek='tabungan rencana') and (arrdata.data[nasabahke].noNasabah=arrrek.rek[j].noNasabah) then
				begin
					rekbenar:=True;
				end;
			end;
		end else
		if(x=3) then
		begin
			for j:=1 to arrrek.Neff do
			begin
				if(norek=arrrek.rek[j].noAkun) and (arrrek.rek[j].jenisRek='tabungan mandiri') and (arrdata.data[nasabahke].noNasabah=arrrek.rek[j].noNasabah) then
				begin
					rekbenar:=True;
				end;
			end;
		end
	end;
	
	procedure help;
	begin
		writeln('> Berikut daftar perintah yang tersedia dalam fitur internet banking');
		writeln('> 1.  load                    : Perintah untuk melakukan load data dari file eksternal');
		writeln('> 2.  login                   : Perintah untuk masuk ke sistem sebagai nasabah');
		writeln('> 3.  lihat rekening          : Perintah untuk melihat rekening yang dimiliki nasabah');
		writeln('> 4.  informasiSaldo          : Perintah untuk melihat informasi saldo rekening.');
		writeln('> 5.  lihatAktivitasTransaksi : Perintah untuk melihat riwayat transaksi');
		writeln('> 6.  pembuatanRekening       : Perintah untuk membuat rekening baru');
		writeln('> 7.  setoran                 : Perintah untuk melakukan setoran tunai');
		writeln('> 8.  penarikan               : Perintah untuk melakukan tarik tunai');
		writeln('> 9.  transfer                : Perintah untuk melakukan transfer dana');
		writeln('> 10. pembayaran              : Perintah untuk melakukan pembayaran');
		writeln('> 11. pembelian               : Perintah untuk melakukan pembelian');
		writeln('> 12. penutupanRekening       : Perintah untuk melakukan penutupan rekening');
		writeln('> 13. perubahanDataNasabah    : Perintah untuk melakukan perubahan data nasabah' );
		writeln('> 14. penambahanAutodebet     : Perintah untuk melakukan penambahan rekening autodebet');
		writeln('> 15. logout                  : Perintah untuk keluar dari sistem');
		writeln('> 16. exit                    : Perintah untuk keluar');
	end;
END.
