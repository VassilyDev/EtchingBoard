-- EtchingBoard by Vassily98. (2019)

with MicroBit.Display;
with MicroBit.Buttons; use MicroBit.Buttons;
with MicroBit.IOs;
with MicroBit.Time;
with MicroBit.Console;

procedure Main is
   menuPreheat : Boolean := False;
   preHeating : Boolean := False;
   menuEtching : Boolean := False;
   etching : Boolean := False;
   mainPage : Boolean := True;
   timeHeat : Integer := 2;
   timeEtching : Integer := 2;
   loopNmb : Integer := 0;
   loopEnd   : Integer := 0;

begin
   MicroBit.IOs.Set(8, False);
   MicroBit.IOs.Set(16, False);
   MicroBit.Display.Clear;
   MicroBit.Display.Display('#');
   MicroBit.Console.Put_Line("Ready");

   loop
      -- Check button A status
      if MicroBit.Buttons.State (Button_A) = Pressed then
         MicroBit.Display.Clear;
         if(mainPage) then
            mainPage := False;
            menuPreheat := True;
            MicroBit.Display.Clear;
            MicroBit.Display.Display(Integer'Image(timeHeat));
         elsif(menuPreheat) then
            menuPreheat := False;
            preHeating := True;
            loopNmb := 0;
            loopEnd := (timeHeat * 60);
            MicroBit.IOs.Set(16, True);
            MicroBit.Display.Display_Async("--HEATING--");
         elsif(menuEtching) then
            menuEtching := False;
            etching := True;
            loopNmb := 0;
            loopEnd := (timeEtching * 60);
            MicroBit.IOs.Set(8, True);
            MicroBit.Display.Display_Async("--ETCHING--");
         elsif(preHeating) then
            MicroBit.Console.Put_Line("ABORT HEATING");
            preHeating := False;
            mainPage := True;
            MicroBit.IOs.Set(16, False);
            MicroBit.Display.Display('#');
         elsif(etching) then
            MicroBit.Console.Put_Line("ABORT ETCHING");
            etching := False;
            mainPage := True;
            MicroBit.IOs.Set(8, False);
            MicroBit.Display.Display('#');
         end if;
      end if;
      -- Check button B status
      if MicroBit.Buttons.State (Button_B) = Pressed then
         MicroBit.Display.Clear;
         if(mainPage) then
            mainPage := False;
            menuEtching := True;
            MicroBit.Display.Clear;
            MicroBit.Display.Display (Integer'Image(timeEtching));
         elsif(menuPreheat) then
            timeHeat := timeHeat + 1;
            MicroBit.Display.Display (Integer'Image(timeHeat));
         elsif(menuEtching) then
            timeEtching := timeEtching + 1;
            MicroBit.Display.Display (Integer'Image(timeEtching));
         end if;
      end if;
      -- Increase loopNmb when heating or etching
      if(preHeating) then
         loopNmb := loopNmb + 1;
         MicroBit.Console.Put("HEATING: ");
         MicroBit.Console.Put(Integer'Image(loopNmb));
         MicroBit.Console.Put("/");
         MicroBit.Console.Put_Line(Integer'Image(loopEnd));
      end if;
      if(etching) then
         loopNmb := loopNmb + 1;
         MicroBit.Console.Put("ETCHING: ");
         MicroBit.Console.Put(Integer'Image(loopNmb));
         MicroBit.Console.Put("/");
         MicroBit.Console.Put_Line(Integer'Image(loopEnd));
      end if;
      -- Check if the timer has reached target time
      if(loopNmb > loopEnd) then
         MicroBit.IOs.Set(16, False);
         MicroBit.IOs.Set(8, False);
         preHeating := False;
         etching := False;
         mainPage := True;
         loopNmb := 0;
         loopEnd := 0;
         MicroBit.Display.Clear;
         MicroBit.Display.Display('#');
      end if;

      MicroBit.Time.Delay_Ms(1000);
   end loop;
end Main;
