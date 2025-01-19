import { Component, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { ButtonModule } from 'primeng/button';
import { ToolbarModule } from 'primeng/toolbar';
import { AvatarModule } from 'primeng/avatar';
import { CommonModule } from '@angular/common';
import { MenuModule } from 'primeng/menu';
import { trigger, transition, animate, style } from '@angular/animations';
import { CardModule } from 'primeng/card';
import { CarouselModule } from 'primeng/carousel';
import { TagModule } from 'primeng/tag';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet,
    CommonModule,
    ButtonModule,
    ToolbarModule,
    AvatarModule,
    MenuModule,
    CardModule,
    CarouselModule,
    TagModule,
    FormsModule
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
  animations: [
    trigger('fadeInOut', [
      transition(':enter', [
        style({ opacity: 0 }),
        animate('1s', style({ opacity: 1 })),
      ]),
      transition(':leave', [
        animate('1s', style({ opacity: 0 })),
      ]),
    ])
  ]
})
export class AppComponent implements OnInit{
  title = 'Jackson';
  titles: string[] = ["We create", "We build", "We innovate", "We are Jackson Store"];
  currentTitle: string = this.titles[0];
  currentIndex: number = 0;

  ngOnInit(): void {
    setInterval(() => {
      this.currentIndex = (this.currentIndex + 1) % this.titles.length;
      this.currentTitle = this.titles[this.currentIndex];
    }, 2000);
  }

  //menumodel


  products: any[] = [
    {
      name: 'Product 1',
      price: 29.99,
      image: 'product1.jpg',
      inventoryStatus: 'In Stock'
    },
    {
      name: 'Product 2',
      price: 49.99,
      image: 'product2.jpg',
      inventoryStatus: 'Out of Stock'
    },
    {
      name: 'Product 3',
      price: 99.99,
      image: 'product3.jpg',
      inventoryStatus: 'Limited Stock'
    },
    {
      name: 'Product 4',
      price: 19.99,
      image: 'product4.jpg',
      inventoryStatus: 'In Stock'
    },
    {
      name: 'Product 5',
      price: 69.99,
      image: 'product5.jpg',
      inventoryStatus: 'In Stock'
    },
    {
      name: 'Product 6',
      price: 89.99,
      image: 'product6.jpg',
      inventoryStatus: 'Out of Stock'
    }
  ];

  // Opciones responsivas para el carrusel
  responsiveOptions = [
    {
        breakpoint: '1024px',
        numVisible: 3,
        numScroll: 3
    },
    {
        breakpoint: '768px',
        numVisible: 2,
        numScroll: 2
    },
    {
        breakpoint: '560px',
        numVisible: 1,
        numScroll: 1
    }
];




  getSeverity(status: string): string {
    switch (status) {
      case 'In Stock':
        return 'success';
      case 'Out of Stock':
        return 'danger';
      case 'Limited Stock':
        return 'warning';
      default:
        return 'info';
    }
  }

}
