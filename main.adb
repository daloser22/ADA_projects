with Text_IO;

procedure main is
   package Int_IO is new Text_IO.Integer_IO (Integer); -- Para leer integers por teclado
   type Contact_T is -- Definimos los campos que van a almacenar cada contacto
      record
         Name: String(1..30) := (others => ' ');
         Number: String(1..9) := (others => ' ');
         Email: String(1..30) := (others => ' ');
         Address: String(1..60) := (others => ' ');
      end record;
   type Agenda_T is array (Positive range 1 .. 100) of Contact_T; -- Definimos este tipo para que las funciones que usen la variable no tengan problemas de si es array o no
   Agenda : Agenda_T;
   option : Integer;
   index : Integer := 1;

   function Main_Menu return Integer is
      option : Integer;
   begin
      Text_IO.Put_Line("Hola ! Soy tu nuevo asistente de contactos");
      Text_IO.Put_Line("-------- MENU -------- :) ");
      Text_IO.Put_Line("1 --> Crear nuevo contacto.");
      Text_IO.Put_Line("2 --> Borrar contacto existente.");
      Text_IO.Put_Line("3 --> Buscar contacto.");
      Text_IO.Put_Line("4 --> Modificar contacto ya existente.");
      Text_IO.Put_Line("5 --> Exportar agenda a fichero .txt.");
      Text_IO.Put_Line("Dime por teclado ¿Que opcion deseas hacer?");
      Int_IO.Get(option);
      return option;
   end Main_Menu;

   procedure NewContact (Agenda: in out Agenda_T; index: in Integer) is
   Last : Natural;
   begin
      Text_IO.Put_Line("Rellene los siguientes campos:");
      Text_IO.Skip_Line; -- Necesario para limpiar el Enter previo del Put_Line
      Text_IO.Put_Line("Nombre de contacto:");
      Text_IO.Get_Line(Agenda(index).Name, Last);
      Text_IO.Put_Line("Numero de telefono:");
      Text_IO.Get_Line(Agenda(index).Number, Last);
      Text_IO.Put_Line("e-mail de contacto:");
      Text_IO.Skip_Line;
      Text_IO.Get_Line(Agenda(index).Email, Last);
      Text_IO.Put_Line("Direccion del contacto:");
      Text_IO.Get_Line(Agenda(index).Address, Last);
      Text_IO.Put_Line("Nuevo conctacto añadido.");
   end NewContact;

   procedure DeleteContact (Agenda: in out Agenda_T) is
      DeleteName : String(1..30) := (others => ' '); -- Necesario inicializar la variable igual que la estructura de arriba para comparar con dos cosas similares
      Last : Natural;
   begin
      Text_IO.Put_Line("Indique el nombre del contacto que desea borrar:");
      Text_IO.Skip_Line; -- Necesario para limpiar el Enter previo del Put_Line
      Text_IO.Get_Line(DeleteName, Last);
      for I in Agenda'Range loop
         if Agenda(I).Name = DeleteName then
            Agenda(I) :=
              (Name => (others => ' '),
               Number => (others => ' '),
               Email => (others => ' '),
               Address => (others => ' '));
            Text_IO.Put_Line("Contacto borrado.");
            exit; -- Salimos del bucle porque ya hemos encontrado lo que queriamos
         else Text_IO.Put_Line("Ese contacto no existe en la agenda.");
         end if;
      end loop;
   end DeleteContact;

   procedure SearchContact (Agenda: in out Agenda_T) is
      SearchName : String(1..30) := (others => ' '); -- Necesario inicializar la variable igual que la estructura de arriba para comparar con dos cosas similares
      Last : Natural;
   begin
      Text_IO.Put_Line("Indique el nombre del contacto que desea buscar:");
      Text_IO.Skip_Line; -- Necesario para limpiar el Enter previo del Put_Line
      Text_IO.Get_Line(SearchName, Last);
      for I in Agenda'Range loop
         if Agenda(I).Name = SearchName then
            Text_IO.Put_Line("Esta es la info del contacto que esta buscando:");
            Text_IO.Put_Line(Agenda(I).Name);
            Text_IO.Put_Line(Agenda(I).Number);
            Text_IO.Put_Line(Agenda(I).Address);
            Text_IO.Put_Line(Agenda(I).Email);
            exit; -- Salimos del bucle ya tenemos lo que buscabamos
         end if;
      end loop;
   end SearchContact;

   procedure ModifyContact (Agenda: in out Agenda_T) is
      ModifyName : String(1..30) := (others => ' '); -- Necesario inicializar la variable igual que la estructura de arriba para comparar con dos cosas similares
      Last : Natural;
   begin
      Text_IO.Put_Line("Indique el nombre del contacto que desea modificar:");
      Text_IO.Get_Line(ModifyName, Last);
      for I in Agenda'Range loop
         if Agenda(I).Name = ModifyName then
            Text_IO.Put_Line("Rellene los nuevos datos del contacto:");
            Text_IO.Skip_Line; -- Necesario para limpiar el Enter previo del Put_Line
            Text_IO.Put_Line("Nombre de contacto:");
            Text_IO.Get_Line(Agenda(I).Name, Last);
            Text_IO.Put_Line("Numero de telefono:");
            Text_IO.Get_Line(Agenda(I).Number, Last);
            Text_IO.Put_Line("e-mail de contacto:");
            Text_IO.Skip_Line;
            Text_IO.Get_Line(Agenda(I).Email, Last);
            Text_IO.Put_Line("Direccion del contacto:");
            Text_IO.Get_Line(Agenda(I).Address, Last);
            Text_IO.Put_Line("Nuevo conctacto añadido.");
            Text_IO.Put_Line(" Contacto modificado. ");
            exit; -- Salimos del bucle porque ya hemos encontrado lo que queriamos
         end if;
      end loop;
   end ModifyContact;

  procedure ExportToFile (Agenda: in out Agenda_T) is
      Fichero : Text_IO.File_Type;
      Empty_line : String(1..30) := (others => ' ');
   begin
      Text_IO.Put_Line("Exportando fichero...");
      Text_IO.Create(Fichero, Text_IO.Out_File, "Agenda.txt");
      for I in Agenda'Range loop
         if Agenda(I).Name /= Empty_line then -- Solo mostramos contactos con contenido valido
            Text_IO.Put_Line(Fichero,"Contacto:");
            Text_IO.Put_Line(Fichero, Agenda(I).Name);
            Text_IO.Put_Line(Fichero, Agenda(I).Number);
            Text_IO.Put_Line(Fichero, Agenda(I).Address);
            Text_IO.Put_Line(Fichero, Agenda(I).Email);
         end if;
      end loop;
      Text_IO.Close (Fichero); -- Mandatory cerrar el fichero.
      Text_IO.Put_Line("Agenda.txt generado con exito");

   end ExportToFile;

begin
   -- Bucle infinito para que el programa siempre muestre el menú principal
   loop
      option := Main_Menu;
      case option is
      when 1 =>
         NewContact(Agenda, index);
         index := index + 1;
         if index = Agenda'Length then
            index := 1; --Sobreescribiremos los registros como una FIFO
         end if;
      when 2 =>
         DeleteContact(Agenda);
      when 3 =>
         SearchContact(Agenda);
      when 4 =>
         ModifyContact(Agenda);
      when 5 =>
         ExportToFile(Agenda);
      when others =>
         Text_IO.Put_Line("Opcion erronea... Seleccione ¿Que deseas hacer?");
      end case;
   end loop;
end main;






