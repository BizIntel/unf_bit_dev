﻿
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ НА СЕРВЕРЕ БЕЗ КОНТЕКСТА

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)	
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНомерПачки(Документ)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "НомерПачки");	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ НА СЕРВЕРЕ

&НаСервере
Процедура СформироватьСфведенияСЗВНаСервере()
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьНомераПачекНаСервере()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОписьПачекСЗВ_6ПачкиДокументов.НомерСтроки,
	               |	ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов,
	               |	ЕСТЬNULL(ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов.НомерПачки, 0) КАК НомерПачки
	               |ИЗ
	               |	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК ОписьПачекСЗВ_6ПачкиДокументов
	               |ГДЕ
	               |	ОписьПачекСЗВ_6ПачкиДокументов.Ссылка = &Ссылка
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ОписьПачекСЗВ_6ПачкиДокументов.НомерСтроки";
				   
	Объект.ПачкиДокументов.Загрузить(Запрос.Выполнить().Выгрузить());				   
				   
КонецПроцедуры	

&НаСервере
Процедура СформироватьФайлПачкиНаСервере(Документ)
	ДокументОбъект = Документ.ПолучитьОбъект();
	ДокументОбъект.ФайлСформирован = Истина;
	ФормироватьФайл = ДокументОбъект.ПроверитьЗаполнение();
	Если ФормироватьФайл Тогда
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьВзносыНаСервере()
	Документы.ОписьПачекСЗВ_6.ЗаполнитьДаннныеОВзносах(Объект.Дата, Объект.ОтчетныйПериод, Объект.Организация, Объект.ПачкиДокументов.Выгрузить().ВыгрузитьКолонку("ПачкаДокументов"));		
КонецПроцедуры	

&НаСервере
Процедура СформироватьФайлНаСервере()
	
КонецПроцедуры	

&НаСервере
Процедура СформироватьФайлыВсехПачекНаСервере()
	
	Для Каждого ПачкаДокументов ИЗ Объект.ПачкиДокументов Цикл
		СформироватьФайлПачкиНаСервере(ПачкаДокументов.ПачкаДокументов);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ (НА КЛИЕНТЕ)

&НаКлиенте
Процедура ЗаполнитьИнфоНадпись()
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьНомераПачекНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьИнфоНадпись();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ОчиститьСообщения();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьНомераПачекНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ЗаполнитьИнфоНадпись();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗаполнитьНомераПачекНаСервере();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ШАПКИ

&НаКлиенте
Процедура ОтчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Если Не (Объект.ОтчетныйПериод = '20100101' И Направление = -1) Тогда
		Объект.ОтчетныйПериод = ДобавитьМесяц(Объект.ОтчетныйПериод, Направление * 3);
	КонецЕсли;	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД

&НаКлиенте
Процедура СформироватьСведения(Команда)
	
	СформироватьСфведенияСЗВНаСервере();
	
	
	Если Не Объект.ДокументПринятВПФР Тогда
		ЗаполнитьИнфоНадпись();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	Объект.ДокументПринятВПФР = Не Объект.ДокументПринятВПФР;
	
	Если Не Объект.ДокументПринятВПФР Тогда
		ТолькоПросмотр = Ложь;
		Элементы.ОтчетныйПериод.Доступность = Истина;
		Элементы.Отменить.Доступность = Ложь;
		ЗаполнитьИнфоНадпись();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФайлПачки(Команда)
	Если Элементы.ПачкиДокументов.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.ПачкиДокументов.ТекущиеДанные.ПачкаДокументов) Тогда
		ОчиститьСообщения();
		СформироватьФайлПачкиНаСервере(Элементы.ПачкиДокументов.ТекущиеДанные.ПачкаДокументов);	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФайлыВсехПачек(Команда)
	ОчиститьСообщения();
	СформироватьФайлыВсехПачекНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВзносы(Команда)
	ЗаполнитьВзносыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФайл(Команда)
	ОчиститьСообщения();
	СформироватьФайлНаСервере();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ "ПачкиДокументов"

&НаКлиенте
Процедура ПачкиДокументовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если Не Объект.ДокументПринятВПФР Тогда
		ЗаполнитьИнфоНадпись();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПачкиДокументовПослеУдаления(Элемент)
	Если Не Объект.ДокументПринятВПФР Тогда
		ЗаполнитьИнфоНадпись();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПачкиДокументовДокументПриИзменении(Элемент)
	СтрокаПачекДокументов = Объект.ПачкиДокументов.НайтиПоИдентификатору(Элементы.ПачкиДокументов.ТекущиеДанные.ПолучитьИдентификатор());
	
	СтрокаПачекДокументов.НомерПачки = ПолучитьНомерПачки(СтрокаПачекДокументов.ПачкаДокументов);
КонецПроцедуры











