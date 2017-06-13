﻿
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияВызовСервераПереопределяемый.ОбновитьПоставляемыеДрайвера();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОперацияЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтотОбъект.Доступность = Истина;
	
	ТекстСообщения = ?(РезультатВыполнения.Результат, НСтр("ru='Операция успешна завершена.'"), РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Оповестить("ОбновитьФормуСпискаДокументовЧекККМ");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСмену(Команда)
	
	ОчиститьСообщения();
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОткрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	ОчиститьСообщения();
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетОТекущемСостоянииРасчетов(Команда)
	
	ОчиститьСообщения();
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьФормированиеОтчетаОТекущемСостоянииРасчетов(ОповещениеПриЗавершении, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

