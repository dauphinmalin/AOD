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
    data_read : Integer;
    S : Float; --sommes de tous les entiers contenus dans le fichier (sommes des proba)
    P : array(0..n-1) of Float; -- ce tableau sert à faire un premier enregistrement des characters présents dans le fichier
    C : array(0..n-1,0..n-1) of Float ; -- C(i,j) = cout de l arbre T(i,j)
    W : array(0..n-1,0..n-1) of Float ; -- W(i,j) = somme des p(k) pour k allant de i à j-1
    TEST : array(0..4) of Integer; -- TEST permet de tester sans lecture de fichier
    j : Integer;
    Cmin : Float; -- Cmin
    m : Integer; -- valeur de k minimisant C(i,k-1)+C(k,j)
    I : Integer; -- Valeur de l'entier (valeur sur un noeud)
    test1 : Integer;
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
    while I <= n-1 and End_Of_File(Fichier) loop
      Integer'Read(Flux,data_read);
      --test:=Integer'Input(Flux);
      --P(I):=Float'Input(Flux); -- Ajout de la proba dans le tableau
      P(I):=Float(data_read);

      Put(Float'Image(S));
      Put(Float'Image(S));
      S := S + (P(I)); -- MaJ de la somme des proba
      I := I + 1; --indice correspondant à l'entiers
    end loop;

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
