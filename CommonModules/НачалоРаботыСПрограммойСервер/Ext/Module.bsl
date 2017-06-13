﻿
// Добавляет необходимые параметры работы клиента при запуске.
//
// Параметры:
//	Параметры - Структура - заполняемые параметры;
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПоказатьОкноНачалоРаботыСПрограммой = НЕ ЗначениеЗаполнено(Константы.ДатаПервогоВходаВСистему.Получить());
	
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	Если РежимРаботы.МодельСервиса Тогда
		
		ПоказатьОкноНачалоРаботыСПрограммой = (ПоказатьОкноНачалоРаботыСПрограммой И НЕ РежимРаботы.ЭтоАдминистраторСистемы);
		
	КонецЕсли;
	
	Параметры.Вставить("ПоказатьОкноНачалоРаботыСПрограммой", ПоказатьОкноНачалоРаботыСПрограммой);
	
КонецПроцедуры

// Регистрирует обработчики поставляемых данных
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "Константа.ДатаПервогоВходаВСистему";
	Обработчик.КодОбработчика = 01;
	Обработчик.Обработчик = НачалоРаботыСПрограммойСервер;
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "Константа.ДатаПервогоВходаВСистему" Тогда
		
		Загружать = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - строка. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт 
	
КонецПроцедуры

//Функция возвращает значение дополнительного параметра
// параметр используется только для целей отладки
Функция ЗначениеДополнительногоПараметра() Экспорт
	
	Возврат ВРЕГ("#NotToBeSet");
	
КонецФункции // ЗначениеДополнительногоПараметра()
