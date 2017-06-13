﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ВключитьИспользованиеРегламентногоЗадания(ОбластьДоступа) Экспорт
	
	РегламентноеЗадание = РегламентноеЗаданиеМетаданные(ОбластьДоступа);
	Если РегламентноеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОбластьДоступа = ОбластьДоступа;
	МенеджерЗаписи.Прочитать();
	
	Если ЗначениеЗаполнено(МенеджерЗаписи.Идентификатор) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("ИмяМетода" , РегламентноеЗадание.ИмяМетода);
		ПараметрыЗадания.Вставить("Расписание", Расписание(РегламентноеЗадание));
		
		Задание = ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		МенеджерЗаписи.Идентификатор = Задание.УникальныйИдентификатор();
		
	Иначе
		
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(РегламентноеЗадание);
		Задание.Использование = Истина;
		Задание.Ключ = Строка(Новый УникальныйИдентификатор);
		Задание.Наименование = РегламентноеЗадание;
		Задание.Расписание = Расписание(РегламентноеЗадание);
		Задание.Записать();
		
		МенеджерЗаписи.Идентификатор = Задание.УникальныйИдентификатор;
		
	КонецЕсли;
	
	МенеджерЗаписи.ОбластьДоступа = ОбластьДоступа;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Функция РегламентноеЗадание(ОбластьДоступа) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаданияОбменаСGoogle.Идентификатор
	|ИЗ
	|	РегистрСведений.ЗаданияОбменаСGoogle КАК ЗаданияОбменаСGoogle
	|ГДЕ
	|	ЗаданияОбменаСGoogle.ОбластьДоступа = &ОбластьДоступа");
	Запрос.УстановитьПараметр("ОбластьДоступа", ОбластьДоступа);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Выборка.Идентификатор);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РегламентноеЗаданиеМетаданные(ОбластьДоступа)
	
	Если ОбластьДоступа = Перечисления.ОбластиДоступаGoogle.Календарь Тогда
		Возврат Метаданные.РегламентныеЗадания.СинхронизацияGoogleCalendar;
	КонецЕсли;
	
	Если ОбластьДоступа = Перечисления.ОбластиДоступаGoogle.Контакты Тогда
		Возврат Метаданные.РегламентныеЗадания.ЗагрузкаКонтактовИзGoogle;
	КонецЕсли;
	
	Если ОбластьДоступа = Перечисления.ОбластиДоступаGoogle.Почта Тогда
		Возврат Метаданные.РегламентныеЗадания.ЗагрузкаЭлектроннойПочты;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция Расписание(РегламентноеЗадание)
	
	Результат = Новый РасписаниеРегламентногоЗадания;
	
	Результат.ПериодПовтораДней = 1;
	
	Если РегламентноеЗадание = Метаданные.РегламентныеЗадания.СинхронизацияGoogleCalendar
		Или РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаЭлектроннойПочты Тогда
		Результат.ПериодПовтораВТечениеДня = 300;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли