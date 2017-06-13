﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ПустаяСтрока(Код) Тогда
		УстановитьНовыйКод();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	УдалитьРегламентноеЗадание();
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Код = "";
	ИдентификаторРегламентногоЗадания = НеОпределено;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРегламентноеЗадание() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Задание;
КонецФункции

Процедура УдалитьРегламентноеЗадание() Экспорт
	Задание = ПолучитьРегламентноеЗадание();
	Если НЕ Задание = НеОпределено Тогда
		УстановитьПривилегированныйРежим(Истина);
		Задание.Удалить();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли