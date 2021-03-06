﻿
#Область ПеременныеФормы

&НаКлиенте
Перем ОбновитьИнтерфейс; // Признак необходимости обновить интерфейс программы

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
		СтрокаПоиска = Параметры.СтрокаПоиска;
	КонецЕсли;
	
	РежимРаботы = Новый ФиксированнаяСтруктура(ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы());
	
	Шаблон = "Конфигурация: [СинонимКонфигурации] ([ВерсияКонфигурации])
				|Платформа: 1С:Предприятие ([ВерсияПлатформы])
				|Идентификатор базы: [ИдентификаторБазы]";
	СисИнфо = Новый СистемнаяИнформация;
	ВставляемыеЗначения = Новый Структура;
	ВставляемыеЗначения.Вставить("СинонимКонфигурации",	Метаданные.Синоним);
	ВставляемыеЗначения.Вставить("ВерсияКонфигурации",	Метаданные.Версия);
	ВставляемыеЗначения.Вставить("ВерсияПлатформы",		СисИнфо.ВерсияПриложения);
	ВставляемыеЗначения.Вставить("ИдентификаторБазы",	СтандартныеПодсистемыСервер.ИдентификаторИнформационнойБазы());
	ИнформацияОПрограмме = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ВставляемыеЗначения);
	
	// РАЗДЕЛЫ НАСТРОЕК
	РазделыНастроек = Обработки.НастройкаПрограммы.НовоеДеревоРазделов();
	НастройкаПрограммыПереопределяемый.РазделыНастроек(РазделыНастроек, РежимРаботы);
	СформироватьОписанияРазделов(РазделыНастроек.Строки);
	ПреобразоватьРазделы(РазделыНастроек);
	ЗначениеВРеквизитФормы(РазделыНастроек, "ДеревоРазделов");
	
	// ОПИСАНИЕ НАСТРОЕК
	НастройкиПрограммы = Обработки.НастройкаПрограммы.НоваяТаблицаНастроек();
	НастройкаПрограммыПереопределяемый.НастройкиПрограммы(НастройкиПрограммы, РежимРаботы);
	СоздатьРеквизитыЗначений(НастройкиПрограммы);
	
	Для Каждого Идентификатор Из ДобавленныеРеквизитыНастроек Цикл
		УстановитьЗначениеРеквизита(Идентификатор);
	КонецЦикла;
	
	СгенерироватьЭлементыНастроек(НастройкиПрограммы);
	
	Для Каждого Настройка Из НастройкиПрограммы Цикл
		
		Если Настройка.ПравоРедактирования Тогда
			НастройкаПрограммыПереопределяемый.ПриОпределенииДоступности(
				Настройка.Идентификатор,
				Элементы[Настройка.Идентификатор],
				ЭтотОбъект
			);
		Иначе
			Элементы[Настройка.Идентификатор].Доступность = Ложь;
		КонецЕсли;
		
		// Начальная установка подсказки для расписаний регламентных заданий
		Если СтрЗаканчиваетсяНа(Настройка.Идентификатор, "Расписание") Тогда
			ИмяПредопределенного = Сред(Настройка.Идентификатор, 1, СтрДлина(Настройка.Идентификатор) - СтрДлина("Расписание"));
			РегламентноеЗадание = ПолучитьПредопределенноеРегламентноеЗадание(ИмяПредопределенного);
			Если РегламентноеЗадание <> Неопределено Тогда
				Элементы[Настройка.Идентификатор].Подсказка = Строка(РегламентноеЗадание.Расписание);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ПреобразоватьНастройкиПрограммы(НастройкиПрограммы, ДеревоРазделов.ПолучитьЭлементы());
	ЗначениеВРеквизитФормы(НастройкиПрограммы, "ОписаниеНастроек");
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		
		РазделыСНастройками = Новый Массив;
		Для Каждого СтрокаНастроек Из НастройкиПрограммы Цикл
			Если РазделыСНастройками.Найти(СтрокаНастроек.Раздел) = Неопределено Тогда
				РазделыСНастройками.Добавить(СтрокаНастроек.Раздел);
			КонецЕсли;
		КонецЦикла;
		УстановитьВидимостьРазделовРекурсивно(ДеревоРазделов.ПолучитьЭлементы(), РазделыСНастройками, Элементы);
		
	Иначе
		
		ВыполнитьПоискСервер();
		
	КонецЕсли;
		
	Если Не ПустаяСтрока(Параметры.РазделПоУмолчанию) Тогда
		
		ИдентификаторСтроки = 0;
		ОбщегоНазначенияКлиентСервер.ПолучитьИдентификаторСтрокиДереваПоЗначениюПоля(
			"Идентификатор",
			ИдентификаторСтроки,
			ДеревоРазделов.ПолучитьЭлементы(),
			Параметры.РазделПоУмолчанию,
			Ложь
		);
		Элементы.ДеревоРазделов.ТекущаяСтрока = ИдентификаторСтроки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		
		Если ДобавленныеРеквизитыНастроек.Найти(Источник) <> Неопределено Тогда
			
			УстановитьЗначениеРеквизита(Источник);
			
		КонецЕсли;
		
		НайденныеСтроки = ОписаниеНастроек.НайтиСтроки(Новый Структура("Идентификатор", Источник));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ОписаниеНастройки = НайденныеСтроки[0];
			Если ОписаниеНастройки.ВлияетНа <> Неопределено Тогда
				ИзменитьДоступностьЗависимыхНастроек(ОписаниеНастройки.ВлияетНа);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ВыполнитьПоискСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	ВыполнитьПоискСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНастроекПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоРазделов.ТекущаяСтрока = Неопределено Или Элементы.ДеревоРазделов.ТекущиеДанные.Видимость = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДеревоРазделов.Развернуть(Элементы.ДеревоРазделов.ТекущаяСтрока);
	
	Элементы.СтраницыНастроек.ТекущаяСтраница = Элементы["Страница_" + Элементы.ДеревоРазделов.ТекущиеДанные.Идентификатор];
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ТекстПисьма = ИнформацияОПрограмме + Символы.ПС + Символы.ПС + СвояВозможность;
	
	Получатель = Новый СписокЗначений;
	Получатель.Добавить("sbm@1c.ru", "Фирма 1С");
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Получатель", Получатель);
	ПараметрыПисьма.Вставить("Тема", "Хочу эти возможности в будущей версии");
	ПараметрыПисьма.Вставить("Текст", ТекстПисьма);
	
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКПодразделу(Элемент)
	
	ИдентификаторРаздела = Сред(Элемент.Имя, СтрДлина("Перейти_")+1);
	
	ИдентификаторСтроки = 0;
	ОбщегоНазначенияКлиентСервер.ПолучитьИдентификаторСтрокиДереваПоЗначениюПоля(
		"Идентификатор",
		ИдентификаторСтроки,
		ДеревоРазделов.ПолучитьЭлементы(),
		ИдентификаторРаздела,
		Ложь
	);
	Элементы.ДеревоРазделов.ТекущаяСтрока = ИдентификаторСтроки;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииПотенциальной(Элемент)
	
	НайденныеСтроки = ОписаниеНастроек.НайтиСтроки(Новый Структура("Идентификатор", Элемент.Имя));
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект[Элемент.Имя] Тогда
		
		СвояВозможность = "# " + НайденныеСтроки[0].Представление + Символы.ПС + СвояВозможность;
		
	Иначе
		
		СвояВозможность = СтрЗаменить(СвояВозможность, "# " + НайденныеСтроки[0].Представление + Символы.ПС, "");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииПоля(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
	ОповещенияНаКлиенте = Новый Массив;
	ИзменениеНастройкиСервер(Элемент.Имя, ОповещенияНаКлиенте);
	
	Для Каждого Оповещение Из ОповещенияНаКлиенте Цикл
		Оповестить(Оповещение.ИмяСобытия, Оповещение.Параметр, Оповещение.Источник);
	КонецЦикла;
	
	ОписаниеНастройки = ОписаниеНастроек.НайтиСтроки(Новый Структура("Идентификатор", Элемент.Имя))[0];
	Если ОписаниеНастройки.ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаГиперссылку(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
	СтандартнаяОбработка = Истина;
	НастройкаПрограммыКлиентПереопределяемый.ОбработкаНажатияГиперссылки(Элемент.Имя, РежимРаботы, СтандартнаяОбработка, ЭтотОбъект);
	
	Если СтандартнаяОбработка Тогда
		
		Если СтрЗаканчиваетсяНа(Элемент.Имя, "Расписание") Тогда
			
			ИмяПредопределенного = Сред(Элемент.Имя, 1, СтрДлина(Элемент.Имя) - СтрДлина("Расписание"));
			РасписаниеРегламентногоЗадания = ПолучитьРасписаниеПредопределенного(ИмяПредопределенного);
			
			Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
				
				ПараметрыВыполнения = Новый Структура;
				ПараметрыВыполнения.Вставить("ИмяПредопределенного", ИмяПредопределенного);
				
				Обработчик = Новый ОписаниеОповещения("ПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
				Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
				Диалог.Показать(Обработчик);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОписанияРазделов(СтрокиДерева)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		СтраницаРаздела = Элементы.Добавить("Страница_" + СтрокаДерева.Идентификатор, Тип("ГруппаФормы"), Элементы.СтраницыНастроек);
		СтраницаРаздела.Вид = ВидГруппыФормы.Страница;
		СтраницаРаздела.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		СтраницаРаздела.ОтображатьЗаголовок = Ложь;
		
		Если Не ПустаяСтрока(СтрокаДерева.Описание) Тогда
			НовыйЭлемент = Элементы.Добавить(СтрокаДерева.Идентификатор, Тип("ДекорацияФормы"), СтраницаРаздела);
			НовыйЭлемент.Вид = ВидДекорацииФормы.Надпись;
			НовыйЭлемент.Заголовок = СтрокаДерева.Описание;
			НовыйЭлемент.ЦветТекста = ЦветаСтиля.ЦветТекстаПодсказки;
			НовыйЭлемент.Высота = 2;
			НовыйЭлемент.Ширина = 70;
			НовыйЭлемент.РастягиватьПоГоризонтали = Ложь;
		КонецЕсли;
		
		ГруппаОбычные = Элементы.Добавить("Обычные_" + СтрокаДерева.Идентификатор, Тип("ГруппаФормы"), СтраницаРаздела);
		ГруппаОбычные.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаОбычные.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ГруппаОбычные.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаОбычные.ОтображатьЗаголовок = Ложь;
		
		ГруппаПереходКПодразделам = Элементы.Добавить("ПереходКПодразделам_" + СтрокаДерева.Идентификатор, Тип("ГруппаФормы"), СтраницаРаздела);
		ГруппаПереходКПодразделам.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаПереходКПодразделам.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ГруппаПереходКПодразделам.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаПереходКПодразделам.ОтображатьЗаголовок = Ложь;
		
		Для Каждого СтрокаПодраздела Из СтрокаДерева.Строки Цикл
			
			ДекорацияПодраздел = Элементы.Добавить("Перейти_" + СтрокаПодраздела.Идентификатор, Тип("ДекорацияФормы"), ГруппаПереходКПодразделам);
			ДекорацияПодраздел.Вид = ВидДекорацииФормы.Надпись;
			ДекорацияПодраздел.Заголовок = СтрокаПодраздела.Представление;
			ДекорацияПодраздел.Гиперссылка = Истина;
			ДекорацияПодраздел.УстановитьДействие("Нажатие", "Подключаемый_ПерейтиКПодразделу");
			
		КонецЦикла;
		
		Если СтрокаДерева.Строки.Количество() = 0 Тогда
			
			ДекорацияОтступ = Элементы.Добавить("Отступ_" + СтрокаДерева.Идентификатор, Тип("ДекорацияФормы"), СтраницаРаздела);
			ДекорацияОтступ.Вид = ВидДекорацииФормы.Надпись;
			
			ГруппаДополнительные = Элементы.Добавить("ДополнительныеВозможности_" + СтрокаДерева.Идентификатор, Тип("ГруппаФормы"), СтраницаРаздела);
			ГруппаДополнительные.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаДополнительные.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			ГруппаДополнительные.Отображение = ОтображениеОбычнойГруппы.Нет;
			ГруппаДополнительные.ЦветФона = ЦветаСтиля.ЦветФонаПотенциальныхВозможностей;
			ГруппаДополнительные.ОтображатьЗаголовок = Ложь;
			
			ГруппаПотенциальные = Элементы.Добавить("Потенциальные_" + СтрокаДерева.Идентификатор, Тип("ГруппаФормы"), ГруппаДополнительные);
			ГруппаПотенциальные.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаПотенциальные.Заголовок = НСтр("ru='Хочу эти возможности в будущей версии'");
			ГруппаПотенциальные.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			ГруппаПотенциальные.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
			ГруппаПотенциальные.ОтображатьЗаголовок = Истина;
			
			ГруппаСвояВозможность = Элементы.Добавить("ГруппаСвояВозможность_" + СтрокаДерева.Идентификатор, Тип("ГруппаФормы"), ГруппаДополнительные);
			ГруппаСвояВозможность.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаСвояВозможность.Заголовок = НСтр("ru='Не нашли нужную возможность? Предложите свою'");
			ГруппаСвояВозможность.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			ГруппаСвояВозможность.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
			ГруппаСвояВозможность.ОтображатьЗаголовок = Истина;
			
			ДекорацияСвояВозможность = Элементы.Добавить("СвояВозможность_" + СтрокаДерева.Идентификатор, Тип("ПолеФормы"), ГруппаСвояВозможность);
			ДекорацияСвояВозможность.Вид = ВидПоляФормы.ПолеВвода;
			ДекорацияСвояВозможность.ПутьКДанным = "СвояВозможность";
			ДекорацияСвояВозможность.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			ДекорацияСвояВозможность.МногострочныйРежим = Истина;
			ДекорацияСвояВозможность.Ширина = 50;
			ДекорацияСвояВозможность.Высота = 3;
			ДекорацияСвояВозможность.РастягиватьПоГоризонтали = Ложь;
			
			КнопкаОтправить = Элементы.Добавить("Отправить_" + СтрокаДерева.Идентификатор, Тип("КнопкаФормы"), ГруппаДополнительные);
			КнопкаОтправить.ИмяКоманды = "Отправить";
			КнопкаОтправить.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Право;
			КнопкаОтправить.Фигура = ФигураКнопки.Овал;
			
		Иначе
			
			СформироватьОписанияРазделов(СтрокаДерева.Строки);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПреобразоватьРазделы(РазделыНастроек)
	
	РазделыНастроек.Колонки.Удалить(РазделыНастроек.Колонки.Описание);
	РазделыНастроек.Колонки.Добавить("Видимость", Новый ОписаниеТипов("Булево"));
	
	ВидимостьРазделовПоУмолчанию(РазделыНастроек.Строки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВидимостьРазделовПоУмолчанию(СтрокиРазделов, Видимость = Истина)
	
	Для Каждого СтрокаРаздела Из СтрокиРазделов Цикл
		
		СтрокаРаздела.Видимость = Видимость;
		Если СтрокаРаздела.Строки.Количество() > 0 Тогда
			ВидимостьРазделовПоУмолчанию(СтрокаРаздела.Строки);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьРеквизитыЗначений(НастройкаПрограммы)
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавленныеРеквизитыНастроекМассив = Новый Массив;
	
	Для Каждого СтрокаНастроек Из НастройкаПрограммы Цикл
		Если ЗначениеЗаполнено(СтрокаНастроек.ТипРеквизита) Тогда
			ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(СтрокаНастроек.Идентификатор, СтрокаНастроек.ТипРеквизита));
			ДобавленныеРеквизитыНастроекМассив.Добавить(СтрокаНастроек.Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	ДобавленныеРеквизитыНастроек = Новый ФиксированныйМассив(ДобавленныеРеквизитыНастроекМассив);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеРеквизита(Идентификатор)
	
	УстановитьПривилегированныйРежим(Истина);
	СтандартнаяОбработка = Истина;
	НастройкаПрограммыПереопределяемый.ПриПолученииЗначенияНастройки(Идентификатор, ЭтотОбъект[Идентификатор], СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		Если Метаданные.НайтиПоПолномуИмени("Константа" + "." + Идентификатор) <> Неопределено Тогда
			МенеджерКонстанты = Константы[Идентификатор];
			ЭтотОбъект[Идентификатор] = МенеджерКонстанты.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СгенерироватьЭлементыНастроек(ТаблицаНастроек)
	
	МассивГрупп = Новый Массив;
	
	Для Каждого СтрокаНастроек Из ТаблицаНастроек Цикл
		
		ГруппаРодитель = Элементы["Обычные_" + СтрокаНастроек.Раздел];
		
		Если Не ПустаяСтрока(СтрокаНастроек.ВместеС) Тогда
			
			Если МассивГрупп.Найти(СтрокаНастроек.ВместеС) = Неопределено Тогда
				
				МассивГрупп.Добавить(СтрокаНастроек.ВместеС);
				
				ГруппаГоризонтальная = Элементы.Добавить("ГруппаГоризонтальная_" + СтрокаНастроек.ВместеС, Тип("ГруппаФормы"), ГруппаРодитель);
				ГруппаГоризонтальная.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				ГруппаГоризонтальная.Отображение = ОтображениеОбычнойГруппы.Нет;
				ГруппаГоризонтальная.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
				ГруппаГоризонтальная.ОтображатьЗаголовок = Ложь;
				
				ДекорацияОтступ = Элементы.Добавить("Группа_" + СтрокаНастроек.ВместеС, Тип("ДекорацияФормы"), ГруппаГоризонтальная);
				ДекорацияОтступ.Вид = ВидДекорацииФормы.Надпись;
				ДекорацияОтступ.Ширина = 3;
				ДекорацияОтступ.РастягиватьПоГоризонтали = Ложь;
				
				ГруппаЗависимых = Элементы.Добавить("ГруппаЗависимых_" + СтрокаНастроек.ВместеС, Тип("ГруппаФормы"), ГруппаГоризонтальная);
				ГруппаЗависимых.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				ГруппаЗависимых.Отображение = ОтображениеОбычнойГруппы.Нет;
				ГруппаЗависимых.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
				ГруппаЗависимых.ОтображатьЗаголовок = Ложь;
				
			КонецЕсли;
			
			ГруппаРодитель = Элементы["ГруппаЗависимых_" + СтрокаНастроек.ВместеС];
			
		ИначеЕсли СтрокаНастроек.Потенциальная Тогда
			
			ГруппаРодитель = Элементы["Потенциальные_" + СтрокаНастроек.Раздел];
			
		КонецЕсли;
		
		Если СтрокаНастроек.ДобавлятьОтступ Тогда
			ДекорацияОтступ = Элементы.Добавить("Отступ_" + СтрокаНастроек.Идентификатор, Тип("ДекорацияФормы"), ГруппаРодитель);
			ДекорацияОтступ.Вид = ВидДекорацииФормы.Надпись;
			ДекорацияОтступ.Высота = 1;
			ДекорацияОтступ.РастягиватьПоВертикали = Ложь;
		КонецЕсли;
		
		НовыйЭлемент = Элементы.Добавить(СтрокаНастроек.Идентификатор, СтрокаНастроек.ТипЭлемента, ГруппаРодитель);
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, СтрокаНастроек.СвойстваЭлемента);
		Если ЗначениеЗаполнено(СтрокаНастроек.ТипРеквизита) Тогда
			НовыйЭлемент.ПутьКДанным = СтрокаНастроек.Идентификатор;
		КонецЕсли;
		Если СтрокаНастроек.СвойстваЭлемента.Свойство("СписокВыбора") Тогда
			Для Каждого ЭлементСписка Из СтрокаНастроек.СвойстваЭлемента.СписокВыбора Цикл
				ЗаполнитьЗначенияСвойств(НовыйЭлемент.СписокВыбора.Добавить(), ЭлементСписка);
			КонецЦикла;
		КонецЕсли;
		
		Если СтрокаНастроек.ТипЭлемента = Тип("ПолеФормы") Тогда
			Если СтрокаНастроек.Потенциальная Тогда
				НовыйЭлемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзмененииПотенциальной");
			Иначе
				НовыйЭлемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзмененииПоля");
			КонецЕсли;
		ИначеЕсли СтрокаНастроек.ТипЭлемента = Тип("ДекорацияФормы") И НовыйЭлемент.Гиперссылка Тогда
			НовыйЭлемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаГиперссылку");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПреобразоватьНастройкиПрограммы(НастройкаПрограммы, КоллекцияЭлементовРазделов)
	
	НастройкаПрограммы.Колонки.Удалить(НастройкаПрограммы.Колонки.ПравоРедактирования);
	НастройкаПрограммы.Колонки.Удалить(НастройкаПрограммы.Колонки.ТипРеквизита);
	НастройкаПрограммы.Колонки.Удалить(НастройкаПрограммы.Колонки.ТипЭлемента);
	НастройкаПрограммы.Колонки.Удалить(НастройкаПрограммы.Колонки.СвойстваЭлемента);
	НастройкаПрограммы.Колонки.Удалить(НастройкаПрограммы.Колонки.ВместеС);
	НастройкаПрограммы.Колонки.Удалить(НастройкаПрограммы.Колонки.ДобавлятьОтступ);
	
	НастройкаПрограммы.Колонки.Добавить("ВлияетНа", Новый ОписаниеТипов);
	
	ВлияниеНастроек = Новый Соответствие;
	Для Каждого СтрокаНастроек Из НастройкаПрограммы Цикл
		
		Если ПустаяСтрока(СтрокаНастроек.Зависимости) Тогда
			Продолжить;
		КонецЕсли;
		
		СписокЗависимостей = СтрРазделить(СтрокаНастроек.Зависимости, ",", Ложь);
		
		Для Каждого ИдентификаторВедущей Из СписокЗависимостей Цикл
			СписокВедомых = ВлияниеНастроек.Получить(ИдентификаторВедущей);
			Если СписокВедомых = Неопределено Тогда
				СписокВедомых = Новый Массив;
			КонецЕсли;
			СписокВедомых.Добавить(СтрокаНастроек.Идентификатор);
			ВлияниеНастроек.Вставить(ИдентификаторВедущей, СписокВедомых);
		КонецЦикла;
		
	КонецЦикла;
	
	Для Каждого СтрокаНастроек Из НастройкаПрограммы Цикл
		
		СписокВедомых = ВлияниеНастроек.Получить(СтрокаНастроек.Идентификатор);
		Если СписокВедомых = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаНастроек.ВлияетНа = Новый ФиксированныйМассив(СписокВедомых);
		
	КонецЦикла;
	
	НастройкаПрограммы.Колонки.Удалить(НастройкаПрограммы.Колонки.Зависимости);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискСервер()
	
	РазделыСНастройками = Новый Массив;
	
	Для Каждого СтрокаНастроек Из ОписаниеНастроек Цикл
		
		НайденоВПредставлении	= СтрНайти(ВРег(СтрокаНастроек.Представление), ВРег(СтрокаПоиска)) > 0;
		НайденоВОписании		= СтрНайти(ВРег(СтрокаНастроек.Описание), ВРег(СтрокаПоиска)) > 0;
		НайденоВТегах			= СтрНайти(ВРег(СтрокаНастроек.Теги), ВРег(СтрокаПоиска)) > 0;
		
		Найдено = НайденоВПредставлении Или НайденоВОписании Или НайденоВТегах;
		Элементы[СтрокаНастроек.Идентификатор].Видимость = Найдено;
		
		Если Найдено И РазделыСНастройками.Найти(СтрокаНастроек.Раздел) = Неопределено Тогда
			РазделыСНастройками.Добавить(СтрокаНастроек.Раздел);
		КонецЕсли;
		
	КонецЦикла;
	
	ЕстьВидимыеРазделы = УстановитьВидимостьРазделовРекурсивно(ДеревоРазделов.ПолучитьЭлементы(), РазделыСНастройками, Элементы);
	
	Если Не ЕстьВидимыеРазделы Тогда
		
		Элементы.СтраницыНастроек.ТекущаяСтраница = Элементы.СтраницаНеНайдено;
		
	ИначеЕсли Элементы.ДеревоРазделов.ТекущаяСтрока = Неопределено 
		Или РазделыСНастройками.Найти(ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока).Идентификатор) = Неопределено Тогда
		
		ИдентификаторСтроки = 0;
		ОбщегоНазначенияКлиентСервер.ПолучитьИдентификаторСтрокиДереваПоЗначениюПоля(
			"Идентификатор",
			ИдентификаторСтроки,
			ДеревоРазделов.ПолучитьЭлементы(),
			РазделыСНастройками[0],
			Ложь
		);
		Элементы.ДеревоРазделов.ТекущаяСтрока = ИдентификаторСтроки;
		Элементы.СтраницыНастроек.ТекущаяСтраница = Элементы["Страница_" + РазделыСНастройками[0]];
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеНастройкиСервер(Идентификатор, ОповещенияНаКлиенте)
	
	Отказ = Ложь;
	ТекстОшибки = "";
	НастройкаПрограммыПереопределяемый.ПриПроверкеКорректностиНастройки(Идентификатор, ЭтотОбъект[Идентификатор], ТекстОшибки, Отказ);
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		
		УстановитьЗначениеРеквизита(Идентификатор);
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , Идентификатор);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	НастройкаПрограммыПереопределяемый.ПриУстановкеЗначенияНастройки(Идентификатор, ЭтотОбъект[Идентификатор], ОповещенияНаКлиенте, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		Если Метаданные.НайтиПоПолномуИмени("Константа" + "." + Идентификатор) <> Неопределено Тогда
			
			МенеджерКонстанты = Константы[Идентификатор];
			Если МенеджерКонстанты.Получить() <> ЭтотОбъект[Идентификатор] Тогда
				
				МенеджерКонстанты.Установить(ЭтотОбъект[Идентификатор]);
				Обработки.НастройкаПрограммы.ДобавитьОповещение(ОповещенияНаКлиенте, "Запись_НаборКонстант", Новый Структура, Идентификатор);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОписаниеНастройки = ОписаниеНастроек.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор))[0];
	Если ОписаниеНастройки.ВлияетНа <> Неопределено Тогда
		Для Каждого Настройка Из ОписаниеНастройки.ВлияетНа Цикл
			НастройкаПрограммыПереопределяемый.ПриОпределенииДоступности(Настройка, Элементы[Настройка], ЭтотОбъект);
		КонецЦикла;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьДоступностьЗависимыхНастроек(ЗависимыеНастройки)
	
	Для Каждого Настройка Из ЗависимыеНастройки Цикл
		НастройкаПрограммыПереопределяемый.ПриОпределенииДоступности(Настройка, Элементы[Настройка], ЭтотОбъект);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УстановитьВидимостьРазделовРекурсивно(ЭлементыДерева, РазделыСНастройками, ЭлементыФормы)
	
	ЕстьВидимыеРазделы = Ложь;
	
	Для Каждого СтрокаДерева Из ЭлементыДерева Цикл
		
		ЕстьПодчиненныеВидимыеРазделы = Ложь;
		ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ПодчиненныеСтроки.Количество() > 0 Тогда
			ЕстьПодчиненныеВидимыеРазделы = УстановитьВидимостьРазделовРекурсивно(ПодчиненныеСтроки, РазделыСНастройками, ЭлементыФормы);
		КонецЕсли;
		
		СтрокаДерева.Видимость = ЕстьПодчиненныеВидимыеРазделы Или РазделыСНастройками.Найти(СтрокаДерева.Идентификатор) <> Неопределено;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭлементыФормы, "Перейти_" + СтрокаДерева.Идентификатор, "Видимость", СтрокаДерева.Видимость);
		
		ЕстьВидимыеРазделы = ЕстьВидимыеРазделы Или СтрокаДерева.Видимость;
		
	КонецЦикла;
	
	Возврат ЕстьВидимыеРазделы;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиРегламентныхЗаданий

&НаСервереБезКонтекста
Функция ПолучитьПредопределенноеРегламентноеЗадание(ИмяПредопределенного)
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Неопределено;
	
	МетаданныеПредопределенного = Метаданные.РегламентныеЗадания.Найти(ИмяПредопределенного);
	Если МетаданныеПредопределенного <> Неопределено Тогда
		Результат = РегламентныеЗадания.НайтиПредопределенное(МетаданныеПредопределенного);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРасписаниеПредопределенного(ИмяПредопределенного)
	
	Результат = Неопределено;
	
	РегламентноеЗадание = ПолучитьПредопределенноеРегламентноеЗадание(ИмяПредопределенного);
	Если РегламентноеЗадание <> Неопределено Тогда
		Результат = РегламентноеЗадание.Расписание;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьРасписаниеПредопределенного(ИмяПредопределенного, Расписание)
	
	РегламентноеЗадание = ПолучитьПредопределенноеРегламентноеЗадание(ИмяПредопределенного);
	Если РегламентноеЗадание <> Неопределено Тогда
		РегламентноеЗадание.Расписание = Расписание;
		РегламентноеЗадание.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьРасписаниеПредопределенного(ПараметрыВыполнения.ИмяПредопределенного, Расписание);
	Элементы[ПараметрыВыполнения.ИмяПредопределенного + "Расписание"].Подсказка = Строка(Расписание);
	
КонецПроцедуры

#КонецОбласти