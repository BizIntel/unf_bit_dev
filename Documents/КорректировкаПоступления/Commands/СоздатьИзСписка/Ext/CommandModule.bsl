﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ПараметрыВыполненияКоманды.Источник=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Лев(ПараметрыВыполненияКоманды.Источник.ИмяФормы,17) = "ЖурналДокументов." Тогда
		СтруктураПараметров = Новый Структура();
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "Контрагент");
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "ВидОперации");
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "Организация");
			
		ОткрытьФорму("Документ.КорректировкаПоступления.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));
	КонецЕсли; 
	
	
КонецПроцедуры
