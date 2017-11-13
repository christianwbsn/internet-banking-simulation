unit filemanagement; 
//untuk meload/ mengubah file dalam file eksternal dan memasukkannya ke dalam array sehingga dapat diproses
//untuk menyimpan data hasil pengolahan pada penyimpanan internal ke file eksternal
interface

	uses sysutils, typeandvar;
		
	{Kumpulan prosedur load data dari file eksternal ke dalam penyimpanan internal(array)}
	procedure loadNasabah;//prosedur untuk melakukan load data nasabah
	procedure loadRekening;//prosedur untuk melakukan load data rekening online
	procedure loadTransaksi;//prosedur untuk melakukan load data transaksi setor dan penarikan
	procedure loadPembayaran;//prosedur untuk melakukan load data pembayaran
	procedure loadPembelian;//prosedur untuk melakukan load data pembelian
	procedure loadTransfer;//prosedur untuk melakukan load data transfer
	procedure loadTukarMataUang;//prosedur untuk melakukan load data Matauang
	procedure loadListBarang;//prosedur untuk melakukan load list barang
	procedure loading(namafile:string);
	
	{Prosedur penulisan/penyimpanan data dari penyimpanan internal ke file eksternal}
	procedure Exit;//prosedur untuk keluar dari program dan menyimpan semua perubahan pada penyimpanan internal ke file eksternal
	
	
	
implementation
	
	procedure loadNasabah;
	begin
			assign(DataNasabah, 'nasabah.txt');
			reset(DataNasabah);
			Index := 0;
			if(EOF(DataNasabah)) then
			begin
				writeln('> Data nasabah kosong. Aplikasi tidak dapat dijalankan');
				isNasabahKosong:=true;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataNasabah, Str1);
				//parsing tiap row dari file external
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].noNasabah:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].noNasabah := arrdata.data[Index].noNasabah+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].nama:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].nama := arrdata.data[Index].nama+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].alamat:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].alamat := arrdata.data[Index].alamat+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].kota:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].kota := arrdata.data[Index].kota+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].email:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].email := arrdata.data[Index].email+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].noTelp:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].noTelp := arrdata.data[Index].noTelp+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].username:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].username := arrdata.data[Index].username+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrdata.data[Index].password:='';
				For i:=mulai to akhir-2 do
				begin
					arrdata.data[Index].password := arrdata.data[Index].password+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]=' ';
				arrdata.data[Index].status:='';
				For i:=mulai to akhir-1 do
				begin
					arrdata.data[Index].status := arrdata.data[Index].status+Str1[i];
				end;
			end;
			until (EOF(DataNasabah));
			arrdata.Neff:=Index;
			close(DataNasabah);
	end;
	
	procedure loadRekening;
	begin
			assign(DataRekening, 'rekening.txt');
			reset(DataRekening);
			Index := 0;
			if (EOF(DataRekening)) then
			begin
				isRekKosong:=True;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataRekening, Str1);
				//parsing tiap row file eksternal
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				arrRek.rek[Index].noAkun:='';
				For i:=mulai to akhir-2 do
				begin
					arrRek.rek[Index].noAkun := arrRek.rek[Index].noAkun+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrRek.rek[Index].noNasabah:='';
				For i:=mulai to akhir-2 do
				begin
					arrRek.rek[Index].noNasabah := arrRek.rek[Index].noNasabah+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrRek.rek[Index].jenisRek:='';
				For i:=mulai to akhir-2 do
				begin
					arrRek.rek[Index].jenisRek := arrRek.rek[Index].jenisRek+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrRek.rek[Index].mataUang:='';
				For i:=mulai to akhir-2 do
				begin
					arrRek.rek[Index].mataUang := arrRek.rek[Index].mataUang+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrRek.rek[Index].saldo:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrRek.rek[Index].setoran:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrRek.rek[Index].rekAutodebet:='';
				For i:=mulai to akhir-2 do
				begin
					arrRek.rek[Index].rekAutodebet := arrRek.rek[Index].rekAutodebet+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrRek.rek[Index].jangkawaktu:='';
				For i:=mulai to akhir-2 do
				begin
					arrRek.rek[Index].jangkaWaktu := arrRek.rek[Index].jangkaWaktu+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
				arrRek.rek[Index].tglTransaksi.DD:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrRek.rek[Index].tglTransaksi.MM:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]=' ';
				Val(Str1[mulai..akhir-1], pos);
					arrRek.rek[Index].tglTransaksi.YY:=pos;
				
			end;
			until (EOF(DataRekening));
			arrRek.Neff:=Index;
			close(DataRekening);
	end;
	
	procedure loadTransaksi;
	begin
			assign(DataTransaksi, 'transaksi.txt');
			reset(DataTransaksi);
			Index := 0;
			if (EOF(DataTransaksi)) then
			begin
				isTransKosong:=True;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataTransaksi, Str1);
				
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTrans.trans[Index].noAkun:='';
				For i:=mulai to akhir-2 do
				begin
					arrTrans.trans[Index].noAkun := arrTrans.trans[Index].noAkun+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTrans.trans[Index].jenisTrans:='';
				For i:=mulai to akhir-2 do
				begin
					arrTrans.trans[Index].jenisTrans := arrTrans.trans[Index].jenisTrans+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTrans.trans[Index].mataUang:='';
				For i:=mulai to akhir-2 do
				begin
					arrTrans.trans[Index].mataUang := arrTrans.trans[Index].mataUang+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrTrans.trans[Index].jumlah:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrTrans.trans[Index].saldo:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrTrans.trans[Index].tglTransaksi.DD:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrTrans.trans[Index].tglTransaksi.MM:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]=' ';
				Val(Str1[mulai..akhir-1], pos);
					arrTrans.trans[Index].tglTransaksi.YY:=pos;	
		end;
			until (EOF(DataTransaksi));
			arrTrans.Neff:=Index;
			close(DataTransaksi);
	end;
	
	procedure loadTransfer;
	begin
			assign(DataTransfer, 'transfer.txt');
			reset(DataTransfer);
			Index := 0;
			if (EOF(DataTransfer)) then
			begin
				isTransfKosong:=True;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataTransfer, Str1);
				
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTransf.transf[Index].noAkunAsal:='';
				For i:=mulai to akhir-2 do
				begin
					arrTransf.transf[Index].noAkunAsal := arrTransf.transf[Index].noAkunAsal+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTransf.transf[Index].noAkunTujuan:='';
				For i:=mulai to akhir-2 do
				begin
					arrTransf.transf[Index].noAkunTujuan := arrTransf.transf[Index].noAkunTujuan+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTransf.transf[Index].jenis:='';
				For i:=mulai to akhir-2 do
				begin
					arrTransf.transf[Index].jenis := arrTransf.transf[Index].jenis+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTransf.transf[Index].namaBankLuar:='';
				For i:=mulai to akhir-2 do
				begin
					arrTransf.transf[Index].namaBankLuar := arrTransf.transf[Index].namaBankLuar+Str1[i];
				end;
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrTransf.transf[Index].mataUang:='';
				For i:=mulai to akhir-2 do
				begin
					arrTransf.transf[Index].mataUang := arrTransf.transf[Index].mataUang+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrTransf.transf[Index].jumlah:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrTransf.transf[Index].saldo:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrTransf.transf[Index].tglTransaksi.DD:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrTransf.transf[Index].tglTransaksi.MM:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]=' ';
				Val(Str1[mulai..akhir-1], pos);
					arrTransf.transf[Index].tglTransaksi.YY:=pos;	
		end;
			until (EOF(DataTransfer));
			arrTransf.Neff:=Index;
			close(DataTransfer);
	end;
	
	procedure loadPembayaran;
	begin
			assign(DataPembayaran, 'pembayaran.txt');
			reset(DataPembayaran);
			Index := 0;
			if (EOF(DataPembayaran)) then
			begin
				isBayarKosong:=True;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataPembayaran, Str1);
				
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBayar.bayar[Index].noAkun:='';
				For i:=mulai to akhir-2 do
				begin
					arrBayar.bayar[Index].noAkun:= arrBayar.bayar[Index].noAkun+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBayar.bayar[Index].jenis:='';
				For i:=mulai to akhir-2 do
				begin
					arrBayar.bayar[Index].jenis := arrBayar.bayar[Index].jenis+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBayar.bayar[Index].rekBayar:='';
				For i:=mulai to akhir-2 do
				begin
					arrBayar.bayar[Index].rekBayar := arrBayar.bayar[Index].rekBayar+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBayar.bayar[Index].mataUang:='';
				For i:=mulai to akhir-2 do
				begin
					arrBayar.bayar[Index].mataUang := arrBayar.bayar[Index].mataUang+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrBayar.bayar[Index].jumlah:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrBayar.bayar[Index].saldo:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrBayar.bayar[Index].tglTransaksi.DD:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrBayar.bayar[Index].tglTransaksi.MM:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]=' ';
				Val(Str1[mulai..akhir-1], pos);
					arrBayar.bayar[Index].tglTransaksi.YY:=pos;	
		end;
			until (EOF(DataPembayaran));
			arrBayar.Neff:=Index;
			close(DataPembayaran);
	end;
	
	procedure loadPembelian;
	begin
			assign(DataPembelian, 'pembelian.txt');
			reset(DataPembelian);
			Index := 0;
			if (EOF(DataPembelian)) then
			begin
				isBeliKosong:=True;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataPembelian, Str1);
				
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBeli.beli[Index].noAkun:='';
				For i:=mulai to akhir-2 do
				begin
					arrBeli.beli[Index].noAkun:= arrBeli.beli[Index].noAkun+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBeli.beli[Index].jenisBrg:='';
				For i:=mulai to akhir-2 do
				begin
					arrBeli.beli[Index].jenisBrg := arrBeli.beli[Index].jenisBrg+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBeli.beli[Index].penyedia:='';
				For i:=mulai to akhir-2 do
				begin
					arrBeli.beli[Index].penyedia := arrBeli.beli[Index].penyedia+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBeli.beli[Index].noTujuan:='';
				For i:=mulai to akhir-2 do
				begin
					arrBeli.beli[Index].noTujuan := arrBeli.beli[Index].noTujuan+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrBeli.beli[Index].mataUang:='';
				For i:=mulai to akhir-2 do
				begin
					arrBeli.beli[Index].mataUang := arrBeli.beli[Index].mataUang+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrBeli.beli[Index].jumlah:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos);
				arrBeli.beli[Index].saldo:= pos;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrBeli.beli[Index].tglTransaksi.DD:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='-';
				Val(Str1[mulai..akhir-1], pos);
					arrBeli.beli[Index].tglTransaksi.MM:=pos;
				
				mulai := akhir+1;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]=' ';
				Val(Str1[mulai..akhir-1], pos);
					arrBeli.beli[Index].tglTransaksi.YY:=pos;	
		end;
			until (EOF(DataPembelian));
			arrBeli.Neff:=Index;
			close(DataPembelian);
	end;
	
	procedure loadTukarMataUang;
	var
		pos1:real;
	begin
			assign(DataMataUang, 'tukarmatauang.txt');
			reset(DataMataUang);
			Index := 0;
			if (EOF(DataMataUang)) then
			begin
				writeln('> Data konversi mata uang kosong. Anda tidak dapat melakukan transaksi');
				isMataUangKosong:=True;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataMataUang, Str1);
				
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2], pos1);
				arrMataUang.tukarUang[Index].nkursAsal:= pos1;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrMataUang.tukarUang[Index].kursAsal:='';
				For i:=mulai to akhir-2 do
				begin
					arrMataUang.tukarUang[Index].kursAsal := arrMataUang.tukarUang[Index].kursAsal+Str1[i];
				end;
					
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				Val(Str1[mulai..akhir-2],pos1);
				arrMataUang.tukarUang[Index].nkursTujuan :=pos1;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]=' ';
				arrMataUang.tukarUang[Index].kursTujuan:='';
				For i:=mulai to akhir-1 do
				begin
					arrMataUang.tukarUang[Index].kursTujuan := arrMataUang.tukarUang[Index].kursTujuan+Str1[i];
				end;	
			end;
			until (EOF(DataMataUang));
			arrMataUang.Neff:=Index;
			close(DataMataUang);
	end;
	
	procedure loadListBarang;
	begin
			assign(DataListBarang, 'listbarang.txt');
			reset(DataListBarang);
			Index := 0;
			if (EOF(DataListBarang)) then
			begin
				writeln('> Data list barang kosong. Anda tidak dapat melakukan pembelian.');
				isListBarangKosong:=True;
			end else
			repeat
			begin
				Index:=Index+1; //index pada array
				readln(DataListBarang, Str1);
				
				mulai:=1; //index untuk mengolah string
				akhir:=mulai;
				Repeat
					akhir:=akhir+1;
				until Str1[akhir]='|';
				arrList.list[Index].jenis:='';
				For i:=mulai to akhir-2 do
				begin
					arrList.list[Index].jenis:= arrList.list[Index].jenis+Str1[i];
				end;
					
				mulai := akhir+2;
				akhir := mulai;
				repeat
				akhir:=akhir+1;
				until Str1[akhir]='|';
				arrList.list[Index].penyedia:='';
				For i:=mulai to akhir-2 do
				begin
					arrList.list[Index].penyedia := arrList.list[Index].penyedia+Str1[i];
				end;
				
				mulai := akhir+2;
				akhir := mulai;
				repeat
					akhir:=akhir+1;
				until Str1[akhir]=' ';
				Val(Str1[mulai..akhir-1], pos);
				arrList.list[Index].harga:= pos;
			end;	
			until (EOF(DataListBarang));
			arrList.Neff:=Index;
			close(DataListBarang);
	end;
	
	procedure loading(namafile:string);
	begin
		if(namafile='rekening.txt')then
		begin
			loadRekening;
			isRekloaded:=True;
		end;
		if(namafile='nasabah.txt')then
		begin
			loadNasabah;
			if(not(isNasabahKosong)) then
			isDataLoaded:= True;
		end;
		If(namafile='transaksi.txt') then
		begin
			loadTransaksi;
			isTransLoaded:=True;
		end;
		If(namafile='transfer.txt')then
		begin
			loadTransfer;
			isTransfLoaded:=True;
		end;
		If(namafile='pembayaran.txt')then
		begin
			loadPembayaran;
			isBayarLoaded:=True;
		end;
		If(namafile='pembelian.txt')then
		begin
			loadPembelian;
			isBeliLoaded:=True;
		end;
		If(namafile='tukarmatauang.txt')then
		begin
			loadTukarMataUang;
			if(not(isMataUangKosong)) then
			isMataUangLoaded:=True;
		end;
		If(namafile='listbarang.txt')then 
		begin
			loadListBarang;
			if(not(isListBarangKosong)) then
			isListBarangLoaded:=True;
		end;
		If(namafile='all')then 
		begin
			loadListBarang;
			if(not(isListBarangKosong)) then
			isListBarangLoaded:=True;
			loadTukarMataUang;
			if(not(isMataUangKosong)) then
			isMataUangLoaded:=True;
			loadPembelian;
			isBeliLoaded:=True;
			loadPembayaran;
			isBayarLoaded:=True;
			loadTransfer;
			isTransfLoaded:=True;
			loadTransaksi;
			isTransLoaded:=True;
			loadNasabah;
			if(not(isNasabahKosong)) then
			isDataLoaded:= True;
			loadRekening;
			isRekloaded:=True;
		end;
	end;
	
	procedure Exit;
	var
		Str1:string;
	begin
		if(isDataLoaded) then
		begin
			assign(DataNasabah,'nasabah.txt'); 
			rewrite(DataNasabah);
			for i:=1 to arrdata.Neff do
			begin
				if not(arrdata.data[i].noNasabah = '') then
				begin
					Str1 := '';
					Str1 := arrdata.data[i].noNasabah + ' | ' + arrdata.data[i].nama + ' | ' + arrdata.data[i].alamat + ' | ' +arrdata.data[i].kota + ' | ' + arrdata.data[i].email + ' | ' + arrdata.data[i].noTelp  + ' | ' + arrdata.data[i].username + ' | ' + arrdata.data[i].password +' | ' + arrdata.data[i].status + ' ';
					writeln(DataNasabah,Str1);
				end;
			end;	
			close(DataNasabah);
		end;
			
		if(isRekLoaded) then
		begin
			assign(DataRekening,'rekening.txt'); 
			rewrite(DataRekening);
			for i:=1 to arrrek.Neff do
			begin
				if not(arrrek.rek[i].noAkun = '')then
				begin
					Str1 := '';
					Str1 := arrrek.rek[i].noAkun + ' | ' + arrrek.rek[i].noNasabah + ' | ' + arrrek.rek[i].jenisRek + ' | ' +arrrek.rek[i].matauang + ' | ' + IntToStr(arrrek.rek[i].saldo) + ' | ' + IntToStr(arrrek.rek[i].setoran)  + ' | ' + arrrek.rek[i].rekAutodebet + ' | ' + arrrek.rek[i].jangkaWaktu +' | ' + IntToStr(arrrek.rek[i].tglTransaksi.DD) + '-'+ IntToStr(arrrek.rek[i].tglTransaksi.MM)+'-'+ IntToStr(arrrek.rek[i].tglTransaksi.YY)+ ' ';
					writeln(DataRekening,Str1);
				end;
			end;	
			close(DataRekening);
		end;
		
		if(istransLoaded) then
		begin
			assign(Datatransaksi,'transaksi.txt'); 
			rewrite(Datatransaksi);
			for i:=1 to NMax do
			begin
				if not(arrtrans.trans[i].noAkun ='')then
				begin
					Str1 := '';
					Str1 := arrtrans.trans[i].noAkun + ' | ' + arrtrans.trans[i].jenisTrans + ' | ' + arrtrans.trans[i].mataUang + ' | ' +IntToStr(arrtrans.trans[i].jumlah) + ' | ' + IntToStr(arrtrans.trans[i].saldo) + ' | ' + IntToStr(arrtrans.trans[i].tglTransaksi.DD) + '-'+ IntToStr(arrtrans.trans[i].tglTransaksi.MM)+'-'+ IntToStr(arrtrans.trans[i].tglTransaksi.YY)+ ' ';
					writeln(Datatransaksi,Str1);
				end;
			end;	
			close(Datatransaksi);
		end;
		
		if(isTransfLoaded) then
		begin
			assign(Datatransfer,'transfer.txt'); 
			rewrite(Datatransfer);
			for i:=1 to NMax do
			begin
				if not(arrtransf.transf[i].noAkunAsal = '')then
				begin
					Str1 := '';
					Str1 := arrtransf.transf[i].noAkunAsal + ' | ' + arrtransf.transf[i].noAkunTujuan + ' | ' + arrtransf.transf[i].jenis +' | ' + arrtransf.transf[i].namaBankLuar +' | ' + arrtransf.transf[i].mataUang + ' | ' +IntToStr(arrtransf.transf[i].jumlah) + ' | ' + IntToStr(arrtransf.transf[i].saldo) + ' | ' + IntToStr(arrtransf.transf[i].tglTransaksi.DD) + '-'+ IntToStr(arrtransf.transf[i].tglTransaksi.MM)+'-'+ IntToStr(arrtransf.transf[i].tglTransaksi.YY)+ ' ';
					writeln(Datatransfer,Str1);
				end;
			end;	
			close(Datatransfer);
		end;
		
		if(isBayarLoaded) then
		begin
			assign(DataPembayaran,'Pembayaran.txt'); 
			rewrite(DataPembayaran);
			for i:=1 to NMax do
			begin
				if not(arrbayar.bayar[i].noAkun = '')then
				begin
					Str1 := '';
					Str1 := arrbayar.bayar[i].noAkun + ' | ' + arrbayar.bayar[i].jenis +' | ' + arrbayar.bayar[i].rekBayar +' | ' + arrbayar.bayar[i].mataUang + ' | ' +IntToStr(arrbayar.bayar[i].jumlah) + ' | ' + IntToStr(arrbayar.bayar[i].saldo) + ' | ' + IntToStr(arrbayar.bayar[i].tglTransaksi.DD) + '-'+ IntToStr(arrbayar.bayar[i].tglTransaksi.MM)+'-'+ IntToStr(arrbayar.bayar[i].tglTransaksi.YY)+ ' ';
					writeln(DataPembayaran,Str1);
				end;
			end;	
			close(DataPembayaran);
		end;
		
		if(isBeliLoaded) then
		begin
			assign(DataPembelian,'Pembelian.txt'); 
			rewrite(DataPembelian);
			for i:=1 to NMax do
			begin
				if not(arrbeli.beli[i].noAkun = '')then
				begin
					Str1 := '';
					Str1 := arrbeli.beli[i].noAkun +  ' | ' + arrbeli.beli[i].jenisBrg +' | ' + arrbeli.beli[i].penyedia +' | ' + arrbeli.beli[i].noTujuan +' | ' + arrbeli.beli[i].mataUang + ' | ' +IntToStr(arrbeli.beli[i].jumlah) + ' | ' + IntToStr(arrbeli.beli[i].saldo) + ' | ' + IntToStr(arrbeli.beli[i].tglTransaksi.DD) + '-'+ IntToStr(arrbeli.beli[i].tglTransaksi.MM)+'-'+ IntToStr(arrbeli.beli[i].tglTransaksi.YY)+ ' ';
					writeln(DataPembelian,Str1);
				end;
			end;	
			close(DataPembelian);
		end;
	end;
	
end.
