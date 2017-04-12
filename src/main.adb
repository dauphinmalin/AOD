with Ada.Text_IO, Ada.Integer_Text_Io, arbre_optimal, Ada.Streams.Stream_IO, Ada.IO_Exceptions, Ada.Command_line;
use Ada.Text_IO, Ada.Integer_Text_Io, arbre_optimal, Ada.Streams.Stream_IO, Ada.Command_line;

procedure main is

n : Integer:= Integer'Value(Argument(1));
type T_Int is array(0..n-1,0..n-1) of Integer;

procedure Open_Fichier(Fichier :out Ada.Streams.Stream_IO.File_Type; Flux: out Stream_Access; Nom_Fichier: in String ) is
  begin
      Open(Fichier,In_File,Nom_Fichier);
      Flux := Stream(Fichier);
  end Open_fichier;

  procedure Mise_En_Place_Optimal(Nom_Fichier : in String; n : in Integer; R : out T_Int) is --Le but est de construire R tel que R(i,j) donne la racine optimal pour l'arbre T(i,j)
    Fichier : Ada.Streams.Stream_IO.File_Type;
    Flux : Stream_Access;
    data_read : Character;
    data_value : Integer:=0;
    add : Boolean;
    data_sum : Integer:=0;
    S : Float; --sommes de tous les entiers contenus dans le fichier (sommes des proba)
    P : array(0..n-1) of Float; -- ce tableau sert à faire un premier enregistrement des characters présents dans le fichier
    C : array(0..n-1,0..n-1) of Float ; -- C(i,j) = cout de l arbre T(i,j)
    W : array(0..n-1,0..n-1) of Float ; -- W(i,j) = somme des p(k) pour k allant de i à j-1

    j : Integer;
    Cmin : Float; -- Cmin
    m : Integer; -- valeur de k minimisant C(i,k-1)+C(k,j)
    I : Integer; -- Valeur de l'entier (valeur sur un noeud)

  begin
    m := -1;
    S := 0.0;
    I := 0;
    for i in 0..(n-1) loop
      for j in 0..(n-1)loop
        R(i,j):=-1;
      end loop;
    end loop;
    for j in 0..n-1 loop
      P(j):=0.0;
      C(j,j):=0.0;
      W(j,j):=0.0;
      R(j,j):=j;
    end loop;
    Open_Fichier(Fichier,Flux,Nom_Fichier);
    Flux := Stream(Fichier);


    --Put("Lecture des donnees: ");

    --while not End_Of_File(Fichier) or I <= n-1 loop -- on lit le fichier
    while I <= n-1 and not End_Of_File(Fichier) loop
      Character'Read(Flux,data_read);
      add:=True;
      if(data_read='0') then
      data_value:=0;
      elsif(data_read='1') then
      data_value:=1;
      elsif(data_read='2') then
      data_value:=2;
      elsif(data_read='3') then
      data_value:=3;
      elsif(data_read='4') then
      data_value:=4;
      elsif(data_read='5') then
      data_value:=5;
      elsif(data_read='6') then
      data_value:=6;
      elsif(data_read='7') then
      data_value:=7;
      elsif(data_read='8') then
      data_value:=8;
      elsif(data_read='9') then
      data_value:=9;
    else if data_sum/=0 then
        Put_Line("valeur ajoutée :" & Integer'Image(data_sum));
        P(I):=Float(data_sum);
        S := S + (P(I));
        I := I + 1;
        data_sum:=0;
      end if;
      add:=False;
    end if;
    if add=True then data_sum:=data_sum*10+data_value;
    end if;
    end loop;
    if data_sum/=0 then
      Put_Line("valeur ajoutée :" & Integer'Image(data_sum));
      P(I):=Float(data_sum);
      S := S + (P(I));
      I := I + 1;
    end if;

    --Put_Line("TEST2");
    Close(Fichier);
    --Put_Line("fermeture du fichier");

    for l in 0..n-1 loop
      P(l):=P(l)/S;
    end loop;

    for l in 1..n-1 loop
      for i in 0..n-1-l loop
        j:= i+l;

        --Put("i =");
        --Put(i);
        --Put("j =");
        --Put(j);
        W(i,j):=W(i,j-1)+P(j);
        Cmin := C(i,j);
        m:=j;
        for k in i..j loop
          if(k<=j) and (k-1>=i) then
            if(C(i,k-1)+C(k,j) < Cmin) then
              Cmin := C(i,k-1)+C(k,j);
              m := k;
              --Put("m =");
              --Put(m);
            end if;
          end if;
        C(i,j):=W(i,j)+C(i,m-1)+C(m,j);
        R(i,j):= m;
        end loop;
      end loop;
    end loop;
    Put(Float'Image(S));
  end Mise_En_Place_Optimal;

  --function Construit_Abr_Optimal(i : Integer; j : Integer; R : in T_Int) return Arbre is
  --  A : Arbre ;
  --begin
  --  A := creer_arbre(R(i,j));
  --  if(i < R(i,j)-1) then
  --    A.filsgauche:= Construit_Abr_Optimal(i, R(i,j)-1,R);
  --  end if;
  --  if(R(i,j)<j) then
  --    A.filsdroit:= Construit_Abr_Optimal(R(i,j),j,R);
  --  end if;
  --  return A;
  --end Construit_Abr_Optimal;

R : T_Int; --Contient en R(i,j) la racine optimal pour l'arbre T(i,j)
A : Arbre;
begin

  Mise_En_Place_Optimal(Argument(2), n, R);
  Put_Line("R :=");
  for i in 0..(n-1) loop
    for j in 0..(n-1)loop
      if(i<=j) then
        New_line(1);
        Put(Integer'Image(R(i,j)));
        Put(i);
        Put(j);
        New_line(1);
      end if;
    end loop;
  end loop;
  --A := Construit_Abr_Optimal(0,n-1,R);

end main;
