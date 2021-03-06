﻿Функция ПолучитьЛьготы() Экспорт
	
	Макет = Справочники.ТорговыеТочки.ПолучитьМакет("Льготы").ПолучитьТекст();
	Значение = ОбщегоНазначения.ЗначениеИзСтрокиXML(Макет);
	Возврат Значение;
	
КонецФункции


Функция ПолучитьТерриторииОсуществленияДеятельности() Экспорт
	
	Макет = Справочники.ТорговыеТочки.ПолучитьМакет("ТерриторииОсуществленияТорговойДеятельности").ПолучитьТекст();
	Значение = ОбщегоНазначения.ЗначениеИзСтрокиXML(Макет);
	Возврат Значение;
	
КонецФункции


Функция ПолучитьСтавки() Экспорт
	
	Макет = Справочники.ТорговыеТочки.ПолучитьМакет("СтавкиТорговогоСбора").ПолучитьТекст();
	Значение = ОбщегоНазначения.ЗначениеИзСтрокиXML(Макет);
	Возврат Значение;
	
КонецФункции


Функция СтационарныйТорговыйОбъект(ТипТорговойТочки) Экспорт
	
	Если СтрНайти("010203",ТипТорговойТочки) > 0 Тогда // Магаизн, Павильон, Рынок
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции