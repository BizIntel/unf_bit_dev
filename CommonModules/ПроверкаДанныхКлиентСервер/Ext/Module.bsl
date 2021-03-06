﻿///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ С ПРОВЕРКОЙ ДАННЫХ НА КЛИЕНТЕ И СЕРВЕРЕ


// Создает описание структур входных параметров обработки провери
// данных согласно спецификации (Обработка.ПроверкаДанных.МодульОбъекта)
//
// Возвращает:
//		Структура (ВходнойПереход,ВыходнойПереход,ПараметрыРаботы)
//
Функция ПолучитьОписаниеСтруктурПараметровПроверкиДанных(Организация) Экспорт
	
	#Если Сервер Тогда
		Дата = ТекущаяДатаСеанса();
	#Иначе
		Дата = ТекущаяДата();
	#КонецЕсли
	ВозвращаяемаяСтруктура = Новый Структура(
		"ВходнойПереход, ВыходнойПереход, ПараметрыРаботы",
		Новый Структура,
		Новый Структура,
		Новый Структура);
	
	ВозвращаяемаяСтруктура.ВходнойПереход = Новый Структура(
		"ИмяПерехода,НавигационныйПереход,Адресация,Параметры",
		"",
		Ложь,
		"",
		Новый Структура);
	
	ВозвращаяемаяСтруктура.ВыходнойПереход = Новый Структура(
		"ИмяПерехода,НавигационныйПереход,Адресация,Параметры,РазрешитьПереходПриОшибках",
		"",
		Ложь,
		"",
		Новый Структура,
		Ложь);
	
	ВозвращаяемаяСтруктура.ПараметрыРаботы = Новый Структура(
		"Организация,СобытиеКПроверке,ПараметрыКонтроля,ПериодПроизвольногоКонтроля",
		Организация,
		Неопределено,
		Новый Структура(
			"СведенияПоОрганизации,
			|ПараметрыУчета,
			|БанковскиеСчета,
			|НачальныеОстатки,
			|ОтрицательныеДенежныеОстаткиБанк,
			|ОтрицательныеДенежныеОстаткиКасса,
			|ОтрицательныеСкладскиеОстатки,
			|ВзаиморасчетыСКонтрагентами,
			|ПериодыРаботыСотрудников,
			|ВзаиморасчетыССотрудниками,
			|КонтрольПроведенных,
			|СведенияПоСотрудникам,
			|КонтрольПроведенных,
			|ЗаполнениеПоказателейЕНВД,
			|НаличиеПоказателейЕНВД,
			|ТарифыСтраховыхВзносов,
			|КорректностьЗаполненияВидовДеятельностиЕНВД,
			|КонтрольДокументовИзУНФ,
			|ТорговыеТочкиРозничнойПродажиАлкоголя,
			|СведенияПоТорговымТочкам",
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Ложь),
		Новый Структура(
			"ДатаНачала,ДатаОкончания",
			Дата(1,1,1),
			Дата));
	
	Возврат ВозвращаяемаяСтруктура;
	
КонецФункции



// Выводит перечень ошибок при объектной расшифровке
//
Процедура ВывестиСообщенияОбОшибкахЗаполнения(ПутьКДанным, ПереченьОшибок) Экспорт
	
	
	Если НЕ (ТипЗнч(ПереченьОшибок) = Тип("Соответствие") 
		ИЛИ ТипЗнч(ПереченьОшибок) = Тип("ФиксированноеСоответствие")) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Ошибка Из ПереченьОшибок Цикл
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Ошибка.Значение,
			,
			Ошибка.Ключ,
			);
		
	КонецЦикла;
	
КонецПроцедуры

// Функция проверяет корректность Кода ОКВЭД
Функция КодОКВЭДСоответствуетТребованиям(Знач ОКВЭД) Экспорт
	
	ОКВЭД = СокрЛП(ОКВЭД);
	Для Инд = 1 По СтрДлина(ОКВЭД) Цикл
		ТекСимв = Сред(ОКВЭД, Инд, 1);
		Если ТекСимв >= "0" И ТекСимв <= "8" Тогда
			ОКВЭД = Лев(ОКВЭД, Инд - 1) + "9" + Сред(ОКВЭД, Инд + 1);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОКВЭД = "99" ИЛИ ОКВЭД = "99.9" ИЛИ ОКВЭД = "99.99" ИЛИ ОКВЭД = "99.99.9" ИЛИ ОКВЭД = "99.99.99";
	
КонецФункции


Функция РегНомерПФРСоответствуетТребованиям(Знач РегНомерПФР) Экспорт
	
	Для Инд = 0 По 8 Цикл
		РегНомерПФР = СтрЗаменить(РегНомерПФР, Строка(Инд), "9");
	КонецЦикла;
	
	Возврат РегНомерПФР = "999-999-999999";
	
КонецФункции 

