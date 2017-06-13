﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметров(ПараметрКоманды);
	ОткрытьФорму(
		"Справочник.ВнеоборотныеАктивы.Форма.ФормаРедактированияСчетовУчета",
		СтруктураПараметров,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруПараметров(ПараметрКоманды)
	
	СтруктураПараметров = Новый Структура(
		"СчетУчета, СчетАмортизации, Ссылка",
		ПараметрКоманды.СчетУчета, ПараметрКоманды.СчетАмортизации, ПараметрКоманды.Ссылка);
		
	Возврат СтруктураПараметров;
	
КонецФункции
