﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка= Ложь;
		Возврат;
	КонецЕсли;

	ТипМассив    = Тип("Массив");
	ТипСтруктура = Тип("Структура");

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
			Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
			ПолучитьТекущегоПользователя = Ложь;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ЭтаФорма.ПараметрыСеанса_ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		ЭтаФорма.ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	ЭтаФорма.БылиИзменения = Ложь;
	ЭтаФорма.ПоказыватьНовостиСОтключеннымОповещением = Параметры.ПоказыватьНовостиСОтключеннымОповещением;
	ЭтаФорма.СкрыватьСписокНовостейДляОднойНовости    = Параметры.СкрыватьСписокНовостейДляОднойНовости;
	ЭтаФорма.ВремяПереносаПоказатьПозжеМинут          = Параметры.ВремяПереносаПоказатьПозжеМинут;

	Если ВРег(Параметры.РежимОткрытияОкна) = ВРег("БлокироватьОкноВладельца") Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе // Все остальные значения
		// По-умолчанию - независимое открытие.
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	КонецЕсли;

	ЭтаФорма.ЗаголовокФормы = Параметры.Заголовок;
	Если ПустаяСтрока(ЭтаФорма.ЗаголовокФормы) = Истина Тогда
		ЭтаФорма.ЗаголовокФормы = "Новости";
	КонецЕсли;

	// Новости могут быть переданы двумя способами:
	// - Непосредственно список новостей.
	ЭтаФорма.ТаблицаНовостей.Очистить();
	Для Каждого ТекущаяНовость Из Параметры.СписокНовостей Цикл
		НоваяСтрока = ЭтаФорма.ТаблицаНовостей.Добавить();
		НоваяСтрока.Новость            = ТекущаяНовость.Значение;
		НоваяСтрока.ТекстНовостиХТМЛ   = ОбработкаНовостейПовтИсп.ПолучитьХТМЛТекстНовостей(ТекущаяНовость.Значение, Новый Структура("ОтображатьЗаголовок", Истина));
		НоваяСтрока.ОповещениеВключено = Истина; // В форме показа очень важных новостей явно показываются новость с включенным оповещением, иначе бы новости не показывались
		НоваяСтрока.Прочтена           = ТекущаяНовость.Пометка;
	КонецЦикла;

	// - Адрес временного хранилища с массивом структур новостей.
	// Если передан адрес временного хранилища, то из этого хранилища берутся только очень важные новости (важность = 1)
	//  с отбором по форме и событию.

	// Могут передать как одно событие в параметре ИдентификаторСобытия, так и несколько в параметре ИдентификаторыСобытий.
	//  Объединить эти параметры в один массив.
	МассивИдентификаторовСобытий = Новый Массив;
	Если Параметры.ИдентификаторыСобытий.Количество() > 0 Тогда
		МассивИдентификаторовСобытий = Параметры.ИдентификаторыСобытий.ВыгрузитьЗначения();
	КонецЕсли;
	Если НЕ ПустаяСтрока(Параметры.ИдентификаторСобытия) Тогда
		МассивИдентификаторовСобытий.Добавить(Параметры.ИдентификаторСобытия);
	КонецЕсли;

	Если СтрДлина(Параметры.АдресМассиваНовостей) > 0 Тогда
		МассивНовостей = ПолучитьИзВременногоХранилища(Параметры.АдресМассиваНовостей);
		Если ТипЗнч(МассивНовостей) = ТипМассив Тогда
			Для Каждого ТекущаяНовость Из МассивНовостей Цикл
				Если ТипЗнч(ТекущаяНовость) = ТипСтруктура Тогда
					Если (ТекущаяНовость.Свойство("Важность")
								И ТекущаяНовость.Важность = 1) Тогда
						Если (ТекущаяНовость.Свойство("Форма")
									И ВРег(ТекущаяНовость.Форма) = ВРег(Параметры.ИдентификаторФормы))
								ИЛИ (ПустаяСтрока(Параметры.ИдентификаторФормы) = Истина) Тогда
							Если (ТекущаяНовость.Свойство("Событие") = Истина)
									ИЛИ (МассивИдентификаторовСобытий.Количество() = 0) Тогда
								Для Каждого ТекущийИдентификаторСобытия Из МассивИдентификаторовСобытий Цикл
									Если (СокрЛП(ВРег(ТекущаяНовость.Событие)) = СокрЛП(ВРег(ТекущийИдентификаторСобытия)))
											ИЛИ (МассивИдентификаторовСобытий.Количество() = 0) Тогда
										НоваяСтрока = ЭтаФорма.ТаблицаНовостей.Добавить();
										ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяНовость);
										НоваяСтрока.Новость            = ТекущаяНовость.Новость;
										НоваяСтрока.ТекстНовостиХТМЛ   = ОбработкаНовостейПовтИсп.ПолучитьХТМЛТекстНовостей(ТекущаяНовость.Новость, Новый Структура("ОтображатьЗаголовок", Истина));
										НоваяСтрока.ОповещениеВключено = ТекущаяНовость.ОповещениеВключено;
										НоваяСтрока.Прочтена           = ТекущаяНовость.Прочтена;
									КонецЕсли;
								КонецЦикла;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Если ЭтаФорма.ПоказыватьНовостиСОтключеннымОповещением <> Истина Тогда
		МассивНовостейСВключеннымОповещением = ЭтаФорма.ТаблицаНовостей.НайтиСтроки(Новый Структура("ОповещениеВключено", Истина));
		Элементы.ТаблицаНовостей.ОтборСтрок = Новый ФиксированнаяСтруктура("ОповещениеВключено", Истина);
		УсловиеОткрытияФормы = (МассивНовостейСВключеннымОповещением.Количество() > 0);
	Иначе
		УсловиеОткрытияФормы = (ЭтаФорма.ТаблицаНовостей.Количество() > 0);
	КонецЕсли;

	ВыводитьКоличествоНовостейВЗаголовке = Истина;

	Если ЭтаФорма.ТаблицаНовостей.Количество() = 1 Тогда
		Если ЭтаФорма.СкрыватьСписокНовостейДляОднойНовости = Истина Тогда
			ВыводитьКоличествоНовостейВЗаголовке = Ложь;
			Элементы.ТаблицаНовостей.Видимость = Ложь;
			// Так как событие "ТаблицаНовостейПриАктивизацииСтроки" не сработает, то подготовить текст новости вручную.
			ТекущиеДанные = ЭтаФорма.ТаблицаНовостей.Получить(0);
			Если ТекущиеДанные <> Неопределено Тогда
				Если ТекущиеДанные.Прочтена <> Истина Тогда
					ЭтаФорма.БылиИзменения = Истина;
				КонецЕсли;
				ТекущиеДанные.Прочтена = Истина;
				ЭтаФорма.ТекстНовости = ТекущиеДанные.ТекстНовостиХТМЛ;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если ВыводитьКоличествоНовостейВЗаголовке = Истина Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы + " (" + ЭтаФорма.ТаблицаНовостей.Количество() + ")";
	Иначе
		ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы;
	КонецЕсли;

	Если ЭтаФорма.ВремяПереносаПоказатьПозжеМинут > 0 Тогда
		Если ЭтаФорма.ТаблицаНовостей.Количество() = 1 Тогда
			ТекстПодсказки = НСтр("ru='Не напоминать про эту новость %ВремяПереносаПоказатьПозжеМинут% минут'");
		Иначе
			ТекстПодсказки = НСтр("ru='Не напоминать про эти новости %ВремяПереносаПоказатьПозжеМинут% минут'");
		КонецЕсли;
		ТекстПодсказки = СтрЗаменить(ТекстПодсказки, "%ВремяПереносаПоказатьПозжеМинут%", ЭтаФорма.ВремяПереносаПоказатьПозжеМинут);
		Элементы.КомандаПоказатьНовостиПозже.РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (
				РольДоступна(Метаданные.Роли.АдминистраторСистемы)
				ИЛИ РольДоступна(Метаданные.Роли.ПолныеПрава)
				ИЛИ РольДоступна(Метаданные.Роли.ЧтениеНовостей)) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	УстановитьУсловноеОформление();

	// Если нет ни одной новости для отображения, то форму не открывать.
	Если УсловиеОткрытияФормы <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуОченьВажныхНовостейПриСозданииНаСервере(
		ЭтаФорма,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы = Истина Тогда
		// Запрещены серверные вызовы и открытие форм.
		// В таком исключительном случае, когда выходят из программы,
		//  можно проигнорировать установку признака прочтенности у новостей.
	Иначе

		Если ЭтаФорма.БылиИзменения = Истина Тогда

			Если НЕ ЭтаФорма.ПараметрыСеанса_ТекущийПользователь.Пустая() Тогда
				СписокОчисткиКонтекстныхНовостей = ЗаписатьИзменениеСостоянияНовостиСервер(
					ЭтаФорма.ТаблицаНовостей,
					ЭтаФорма.ПараметрыСеанса_ТекущийПользователь);

				// Для новостей с отключенным признаком Оповещение очистить кэш контекстных новостей.
				Для Каждого ПараметрыКонтекстнойНовости Из СписокОчисткиКонтекстныхНовостей Цикл
					ОбработкаНовостейКлиент.УдалитьКонтекстныеНовостиИзКэшаПриложения(
						ПараметрыКонтекстнойНовости.Значение,
						ПараметрыКонтекстнойНовости.Представление);
				КонецЦикла;
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстНовостиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	Если (ЭтаФорма.СкрыватьСписокНовостейДляОднойНовости = Истина)
			И (ЭтаФорма.ТаблицаНовостей.Количество() = 1) Тогда // Таблица скрыта
		ТекущиеДанные = ЭтаФорма.ТаблицаНовостей.Получить(0);
	Иначе
		ТекущиеДанные = Элементы.ТаблицаНовостей.ТекущиеДанные;
	КонецЕсли;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(
			ТекущиеДанные.Новость,
			ДанныеСобытия,
			СтандартнаяОбработка,
			ЭтаФорма,
			Элемент);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТаблицаНовостей

&НаКлиенте
Процедура ТаблицаНовостейПриАктивизацииСтроки(Элемент)

	Если (ЭтаФорма.СкрыватьСписокНовостейДляОднойНовости = Истина)
			И (ЭтаФорма.ТаблицаНовостей.Количество() = 1) Тогда // Таблица скрыта
		ТекущиеДанные = ЭтаФорма.ТаблицаНовостей.Получить(0);
	Иначе
		ТекущиеДанные = Элементы.ТаблицаНовостей.ТекущиеДанные;
	КонецЕсли;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.Прочтена <> Истина Тогда
			ЭтаФорма.БылиИзменения = Истина;
		КонецЕсли;
		ТекущиеДанные.Прочтена = Истина;
		ЭтаФорма.ТекстНовости = ТекущиеДанные.ТекстНовостиХТМЛ;
		Оповестить(
			"Новости. Новость прочтена",
			Истина,
			ТекущиеДанные.Новость);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаБольшеНеПоказывать(Команда)

	Если (ЭтаФорма.СкрыватьСписокНовостейДляОднойНовости = Истина)
			И (ЭтаФорма.ТаблицаНовостей.Количество() = 1) Тогда // Таблица скрыта
		ТекущиеДанные = ЭтаФорма.ТаблицаНовостей.Получить(0);
	Иначе
		ТекущиеДанные = Элементы.ТаблицаНовостей.ТекущиеДанные;
	КонецЕсли;
	Если ТекущиеДанные <> Неопределено Тогда
		ЭтаФорма.БылиИзменения = Истина;
		ТекущиеДанные.ОповещениеВключено = Ложь;
		Оповестить(
			"Новости. Изменено состояние оповещения о новости",
			Ложь,
			ТекущиеДанные.Новость);
	КонецЕсли;

	Если ЭтаФорма.ПоказыватьНовостиСОтключеннымОповещением <> Истина Тогда
		Элементы.ТаблицаНовостей.ОтборСтрок = Новый ФиксированнаяСтруктура("ОповещениеВключено", Истина);
	КонецЕсли;

	ВсегоНовостей = 0;
	Для Каждого ТекущаяНовость Из ЭтаФорма.ТаблицаНовостей Цикл
		Если ТекущаяНовость.ОповещениеВключено = Истина Тогда
			ВсегоНовостей = ВсегоНовостей + 1;
		КонецЕсли;
	КонецЦикла;

	Если (ЭтаФорма.СкрыватьСписокНовостейДляОднойНовости = Истина)
			И (ЭтаФорма.ТаблицаНовостей.Количество() = 1) Тогда // Таблица скрыта
		ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы;
	Иначе
		ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы + " (" + ВсегоНовостей + ")";
	КонецЕсли;

	// Если не осталось ни одной отображаемой новости, то закрыть форму.
	Если ВсегоНовостей = 0 Тогда
		ЭтаФорма.Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьНовостиПозже(Команда)

	// "Отложить" все новости на "ВремяПереносаПоказатьПозжеМинут" минут.
	ДатаДляРегистров = УниверсальноеВремя(ТекущаяДата()) + ЭтаФорма.ВремяПереносаПоказатьПозжеМинут*60;
	Для Каждого ТекущаяНовость Из ЭтаФорма.ТаблицаНовостей Цикл
		ТекущаяНовость.ДатаНачалаОповещения = ДатаДляРегистров;
		ЭтаФорма.БылиИзменения = Истина;
	КонецЦикла;

	ЭтаФорма.Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
// Функция записывает регистр сведений "СостоянияНовостей".
// Также подготавливается список данных для очистки кэша контекстных новостей.
//
// Параметры:
//  лкТаблицаНовостей - ТаблицаЗначений - все новости;
//  лкТекущийПользователь - СправочникСсылка.Пользователи.
//
// Возвращаемое значение:
//   СписокЗначений - список данных, для которых надо очистить кэш контекстных новостей:
//     * Значение - ИдентификаторМетаданных;
//     * Представление - ИдентификаторФормы.
//
Функция ЗаписатьИзменениеСостоянияНовостиСервер(Знач лкТаблицаНовостей, лкТекущийПользователь)

	МассивНовостейДляОчисткиКэшаКонтекстныхНовостей = Новый Массив;

	Для Каждого ТекущаяНовость Из лкТаблицаНовостей Цикл
		Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
		Запись.Пользователь = лкТекущийПользователь;
		Запись.Новость      = ТекущаяНовость.Новость;
		Запись.Прочитать(); // Запись будет ниже. // На тот случай, если были установлены другие свойства
		// Вдруг новость не выбрана (т.е. ее нет в базе) - перезаполнить менеджер записи и записать.
		Запись.Пользователь         = лкТекущийПользователь;
		Запись.Новость              = ТекущаяНовость.Новость;
		Запись.Прочтена             = ТекущаяНовость.Прочтена;
		// Запись.Пометка Не трогать.
		Запись.ОповещениеВключено   = ТекущаяНовость.ОповещениеВключено;
		Запись.ДатаНачалаОповещения = ТекущаяНовость.ДатаНачалаОповещения; // При нажатии "Показать позже" надо отвести время показа на "ВремяПереносаПоказатьПозжеМинут" минут.
		Запись.Записать(Истина);
		Если ТекущаяНовость.ОповещениеВключено = Ложь Тогда
			МассивНовостейДляОчисткиКэшаКонтекстныхНовостей.Добавить(ТекущаяНовость.Новость);
		КонецЕсли;
	КонецЦикла;

	СписокДанныхДляОчисткиКэшаКонтекстныхНовостей = Новый СписокЗначений;

	Если МассивНовостейДляОчисткиКэшаКонтекстныхНовостей.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Спр.Метаданные КАК ИдентификаторМетаданных,
			|	Спр.Форма      КАК ИдентификаторФормы
			|ИЗ
			|	Справочник.Новости.ПривязкаКМетаданным КАК Спр
			|ГДЕ
			|	Спр.Ссылка В (&МассивНовостейДляОчисткиКэшаКонтекстныхНовостей)
			|";
		Запрос.УстановитьПараметр("МассивНовостейДляОчисткиКэшаКонтекстныхНовостей", МассивНовостейДляОчисткиКэшаКонтекстныхНовостей);

		Результат = Запрос.Выполнить(); // ЗаписатьИзменениеСостоянияНовостиСервер()
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.Прямой);
			Пока Выборка.Следующий() Цикл
				СписокДанныхДляОчисткиКэшаКонтекстныхНовостей.Добавить(
					Выборка.ИдентификаторМетаданных,
					Выборка.ИдентификаторФормы);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат СписокДанныхДляОчисткиКэшаКонтекстныхНовостей;

КонецФункции

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Жирным шрифтом непрочтенные новости.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостей.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаНовостей.Прочтена");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(Элементы.ТаблицаНовостей.Шрифт, , , Истина)); // Жирный

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

// Процедура для работы с закэшированной формой новостей - форма уже в памяти, надо установить ей список новостей и открыть.
//
// Параметры:
//  лкЗаголовокФормы - Строка - заголовок формы;
//  лкСписокНовостей - СписокЗначений - список новостей, где:
//    * Значение      - СправочникСсылка.Новости;
//    * Представление - Строка (36) - уникальный идентификатор новости;
//    * Пометка       - Булево - Признак прочтенности, Истина - новость прочтена.
//
&НаКлиенте
Процедура УстановитьСписокНовостей(лкЗаголовокФормы, лкСписокНовостей) Экспорт

	ЭтаФорма.ЗаголовокФормы = лкЗаголовокФормы;
	Если ПустаяСтрока(ЭтаФорма.ЗаголовокФормы) = Истина Тогда
		ЭтаФорма.ЗаголовокФормы = "Новости";
	КонецЕсли;

	ЭтаФорма.ТаблицаНовостей.Очистить();
	Для Каждого ТекущаяНовость Из лкСписокНовостей Цикл
		НоваяСтрока = ЭтаФорма.ТаблицаНовостей.Добавить();
		НоваяСтрока.Новость            = ТекущаяНовость.Значение;
		НоваяСтрока.ТекстНовостиХТМЛ   = ОбработкаНовостейКлиентПовтИсп.ПолучитьХТМЛТекстНовостей(ТекущаяНовость.Значение, Новый Структура("ОтображатьЗаголовок", Истина));
		НоваяСтрока.ОповещениеВключено = Истина;
		НоваяСтрока.Прочтена           = ТекущаяНовость.Пометка;
	КонецЦикла;

	Если ЭтаФорма.ПоказыватьНовостиСОтключеннымОповещением <> Истина Тогда
		Элементы.ТаблицаНовостей.ОтборСтрок = Новый ФиксированнаяСтруктура("ОповещениеВключено", Истина);
	КонецЕсли;

	Если (ЭтаФорма.СкрыватьСписокНовостейДляОднойНовости = Истина)
			И (ЭтаФорма.ТаблицаНовостей.Количество() = 1) Тогда // Таблица скрыта
		ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы;
	Иначе
		ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы + " (" + ЭтаФорма.ТаблицаНовостей.Количество() + ")";
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
