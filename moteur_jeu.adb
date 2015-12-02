with Participant; use Participant; 
with Liste_Generique;
with Ada.Text_IO;


package body Moteur_Jeu is
   
   -- ...
   function Choix_Coup(E: Etat; P : Natural) return Coup is
      V : Integer := -1000;
      Eval_Noeud : Integer := 0;
      Coup_Liste : Liste_Coups := Creer_Liste;
      Coup_Iter : Iterator;
      Temp : Coup;
      Le_Coup : Coup;
   begin
      -- AI est toujours Joueur1
      Coup_Liste := Coups_Possibles(E, Joueur1);
      Coup_Iter := Creer_Iterateur(Coup_Liste);
      loop
	 Temp := Coup_Liste.Element_Courant(Coup_Iter);
	 Eval_Noeud := Eval_Min_Max(E, P - 1, Temp, Joueur1);
	 if Eval_Noeud > V then
	   V := Eval_Noeud;
	   Le_Coup := Temp;
	 end if;
	 exit when A_Suivant(Coup_Iter) = null;
	 Suivant(Coup_Iter);
      end loop;
      Coup_Liste.Libere_Iterateur(Coup_Iter);
      Le_Coup
      
      return Le_Coup;
   end Choix_Coup;
   
   -- ...
   function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur) return Integer is
      Possible_State : Etat;
      V : Integer;
   begin
      Possible_State := Etat_Suivant(E, C);
      if P = 0 then
	 return Eval(Possible_State);
      end if;
      -- P > 0
      if Est_Gagnant(Possible_State, J) then
	 return 1000;
      end if;
      if Est_Gagnant(Possible_State, Adversaire(J)) then
	 return -1000;
      end if;
      if Est_Nul(Possible_State) then
	 return 0;
      end if;
      -- if maximizing player
      if J = Joueur1 then
	 V := -1000;
	 -- for each child of node
	 Coup_Liste := Coups_Possibles(Possible_State, J);
	 Coup_Iter := Creer_Iterateur(Coup_Liste);
	 loop
	    Temp := Coup_Liste.Element_Courant(Coup_Iter);
	    Eval_Noeud := Eval_Min_Max(Possible_State, P - 1, Temp, Joueur2);
	    if Eval_Noeud > V then
	       V := Eval_Noeud;
	       -- Le_Coup := Temp;
	    end if;
	    exit when A_Suivant(Coup_Iter) = null;
	    Suivant(Coup_Iter);
	 end loop;
	 Coup_Liste.Libere_Iterateur(Coup_Iter);
	 return V;
      else
	 V := 1000;
	 Coup_Liste := Coups_Possibles(Possible_State, J);
	 Coup_Iter := Creer_Iterateur(Coup_Liste);
	 loop
	    Temp := Coup_Liste.Element_Courant(Coup_Iter);
	    Eval_Noeud := Eval_Min_Max(Possible_State, P - 1, Temp, Joueur1);
	    if Eval_Noeud < V then
	       V := Eval_Noeud;
	       -- Le_Coup := Temp;
	    end if;
	    exit when A_Suivant(Coup_Iter) = null;
	    Suivant(Coup_Iter);
	 end loop;
	 Coup_Liste.Libere_Iterateur(Coup_Iter);
	 return V;
      end if;
      -- default
      return 0;
   end Eval_Min_Max;
   
end Moteur_Jeu;
