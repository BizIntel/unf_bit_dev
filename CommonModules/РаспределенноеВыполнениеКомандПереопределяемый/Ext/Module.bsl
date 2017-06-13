﻿////////////////////////////////////////////////////////////////////////////////
// РаспределенноеВыполнениеКомандПереопределяемый: переопределяемая часть
// подсистемы РаспределенноеВыполнениеКоманд.
////////////////////////////////////////////////////////////////////////////////

// Экспортные процедуры и функции для вызова из других модулей
// 
#Область ПрограммныйИнтерфейс

// Вызывается при получении сообщения о передаче файла из другой области данных.
//
// Параметры:
//	ИмяФайла - Строка - полное имя к передаваемому файлу.
//	ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//	КодОтправителя - Число - код области данных, откуда быд передан файл.
//	ПараметрыВызова - Структура - дополнительные параметры вызова,
//						*Код (Число), *Тело (Строка).
//
// Возвращаемое значение:
//   Булево   - признак успешной обработки сообщения.
//
Функция ОбработатьЗапросНаПередачуФайла(ИмяФайла, ИдентификаторВызова, КодОтправителя, ПараметрыВызова) Экспорт
	
	Попытка
		Результат = ИнтеграцияОбменШтрихМ.ЗагрузитьДанныеОбменаИз1СКасса(ИмяФайла);
		ИнтеграцияОбменШтрихМ.ВключитьРозничныеПродажи();
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		
		ЗаписьЖурналаРегистрации(
			"Загрузка1СКасса.Загрузка1СКасса",
			УровеньЖурналаРегистрации.Ошибка,,, 
			ОписаниеОшибки);
			
		РаспределенноеВыполнениеКоманд.ВыслатьКвитанциюПередачиФайла(ИдентификаторВызова, КодОтправителя, Ложь, ПараметрыВызова);
		Возврат Ложь;
	КонецПопытки;
	
	РаспределенноеВыполнениеКоманд.ВыслатьКвитанциюПередачиФайла(ИдентификаторВызова, КодОтправителя, Ложь, ПараметрыВызова);
	Возврат Истина;
	
КонецФункции // ОбработатьЗапросНаПередачуФайла()

// Вызывается при получении квитанции на передачу файла из другой области данных.
//
// Параметры:
//	ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//	КодОтправителя - Число - код области данных, откуда быд передан файл.
//	ПараметрыВызова - Структура - дополнительные параметры вызова,
//						*Код (Число), *Тело (Строка).
//
// Возвращаемое значение:
//   Булево   - признак успешной обработки сообщения.
//
Функция ОбработатьОтветНаПередачуФайла(ИдентификаторВызова, КодОтправителя, ПараметрыВызова) Экспорт
	
	Возврат Истина;
	
КонецФункции // ОбработатьОтветНаПередачуФайла() 

// Вызывается при получении квитанции на передачу файла из другой области данных.
//
// Параметры:
//	ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//	КодОтправителя - Число - код области данных, откуда быд передан файл.
//	ТекстОшибки - Строка - описание возникшей ошибки 
//
// Возвращаемое значение:
//   Булево   - признак успешной обработки сообщения.
//
Функция ОбработатьОшибкуПередачиФайла(ИдентификаторВызова, КодОтправителя, ТекстОшибки) Экспорт
	
	Возврат Истина;
	
КонецФункции // ОбработатьОшибкуПередачиФайла() 

#КонецОбласти  

