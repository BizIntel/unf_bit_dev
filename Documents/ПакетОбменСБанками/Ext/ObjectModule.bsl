﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭДПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ПакетОбменСБанкамиПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", Ссылка);
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока результат.Следующий() Цикл
		Объект = Результат.Ссылка.ПолучитьОбъект();
		Объект.ПометкаУдаления = ПометкаУдаления;
		Объект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли