﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Функция возвращает табличный документ для печати ТН
//
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент			= Новый ТабличныйДокумент;
	Макет 						= ПолучитьМакет("ПФ_MXL_ТранспортнаяНакладная");
	
	Если ТипЗнч(МассивОбъектов) = Тип("Массив") 
		И МассивОбъектов.Количество() > 0 Тогда
		
		ТекущийДокумент 		= МассивОбъектов[0];
		
	Иначе
		
		ТекущийДокумент 		= Неопределено;
		
	КонецЕсли;
	
	НомерСтрокиНачало 						= ТабличныйДокумент.ВысотаТаблицы + 1;
	ТабличныйДокумент.ИмяПараметровПечати 	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПечатьТН_ТН";
	
	//:::Лицевая
	ОбластьМакета 				= Макет.ПолучитьОбласть("ЧастьПервая");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	//:::Оборотная
	ОбластьМакета 				= Макет.ПолучитьОбласть("ЧастьВторая");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции // ПечатнаяФорма()

// Сформировать печатную форму
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ТН", "Приложение № 4 к Правилам перевозок грузов автомобильным транспортом", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
	
КонецПроцедуры

#КонецЕсли